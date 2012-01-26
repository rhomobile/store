(function($){

    var callbackCount = 0;
    var pendingCallbacks = {};

    function normalizeAjaxOptions(urlOrOptions, options) {
        if ('string' == typeof urlOrOptions && 'object' == typeof options) {
            return $.extend({}, {url: urlOrOptions}, options);
        } else if ('object' == typeof urlOrOptions) {
            return urlOrOptions;
        }
        return {};
    }

    var _ajax = jQuery.ajax;

    function wp7ajax() {
        // there may be ajax(options) or ajax(url, options) form of call
        var options = normalizeAjaxOptions.apply(this, arguments);

        // if we have URL in request options and it is a local URL
        if (options.url.match(/^https?:\/\/(127\.0\.0\.1|localhost)/)) {
            // then call proxy
            return wp7notifyProxy.apply(this, [options]);
        }
        // else, let default AJAX function to handle it
        return _ajax.apply(this, arguments);
    }

    jQuery.ajax = wp7ajax;

    function wp7notifyProxy(options) {
        /*
         * IMPORTANT NOTE! ===========================================
         * At the moment this implementation doesn't support anything
         * besides GET request. No headers, cookies, response status
         * codes, etc. Just request parameters and response content.
         * ===========================================================
         */

        // set next call id value
        options.data = options.data || {};
        options.data._rho_callbackId = "_rhoId#" + callbackCount++;

        // set deferred object to resolve/reject late
        options._rho_deferred = $.Deferred();

        // store options for pending callback
        pendingCallbacks[options.data._rho_callbackId] = options;

        // compose GET request formatted URI
        var request = options.url;
        var isFirstParam = true;
        $.each(options.data, function(name, value){
            request = request + ((isFirstParam ? '?' : '&')
                +encodeURIComponent(name) +'=' +encodeURIComponent(value));
            isFirstParam = false;
        });

        //console.log('AJAX: this = ' +this +' arguments = ' +arguments);
        console.log('wrapped AJAX request URI:' + request);
        return _ajax.apply(this, arguments);
        //return window.external.notify(request);

    }

    function fireHandlers(options, result, status, errCode) {
        // TODO: fake jqXHR needs to be provided
        var jqXHR = null;

        if ("error" == status) {
            if ('function' == typeof options.error) {
                // start handler asynchronously
                setTimeout(function(){
                    options.error.apply(this, [jqXHR, status, result]);
                }, 1);
            }
            if ('object' == typeof options._rho_deferred) {
                options._rho_deferred.resolve([jqXHR, status, result]);
            }
        } else {
            if ('function' == typeof options.success) {
                // start handler asynchronously
                setTimeout(function(){
                    options.success.apply(this, [result, status, jqXHR]);
                }, 1);
            }
            if ('object' == typeof options._rho_deferred) {
                options._rho_deferred.resolve([result, status, jqXHR]);
            }
        }
    }

    window._rho_ajaxProxyCallback = function(callbackId, result, status, errCode) {
        if (pendingCallbacks[callbackId]) {
            fireHandlers(pendingCallbacks[callbackId], result, status, errCode);
            delete pendingCallbacks[callbackId];
        }
    };


})(jQuery);
