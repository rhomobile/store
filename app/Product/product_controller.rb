require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'

class ProductController < Rho::RhoController
  include BrowserHelper
  include ApplicationHelper

  #GET /Product
  def index
    @products = Product.find(:all)
    add_objectnotify(@products)
    render
  end

  # GET /Product/{1}
  def show
    # Only run async for when supporting transitions
    if @request['headers']['Jqtouch']
      # This is an example of how to transition from an async http request. See show_callback below
      # for completed transition.
      Rho::AsyncHttp.get(
              :url =>  "http://rhostore.heroku.com/products/#{@params['product_id']}.json",
              :callback => (url_for :action => :show_callback),
              :callback_param => "")

      # A Wait-Page response header notifies JavaScript that an async request has been spawned and that the current
      # rendering page should be treated as an interstitial page. Here we send back a waiting screen. Note that
      # interstitial pages are not treated as part of the browser's history.
      @response['headers']['Wait-Page'] = 'true'
      render :action => :waiting
    else
      @product = Product.find(@params['id'])
      render :action => :show
    end
  end

  # GET /Product/new
  def new
    @product = Product.new
    render :action => :new
  end

  # GET /Product/{1}/edit
  def edit
    @product = Product.find(@params['id'])
    if @product
      render :action => :edit
    else
      redirect :action => :index
    end
  end

  # POST /Product/create
  def create
    @product = Product.new(@params['product'])
    @product.save

    # immediately send to the server and show index after sync
    Product.set_notification("/app/Product/show_index_after_sync", "do_transition=#{@request['headers']['Jqtouch']}")
    SyncEngine.dosync_source(@product.source_id)

    @response['headers']['Wait-Page'] = 'true'
    render :action => :waiting
  end

  # POST /Product/{1}/update
  def update
    @product = Product.find(@params['id'])
    @product.update_attributes(@params['product'])

    # immediately send to the server and show index after sync
    Product.set_notification("/app/Product/show_index_after_sync", "do_transition=#{@request['headers']['Jqtouch']}")
    SyncEngine.dosync_source(@product.source_id)

    @response['headers']['Wait-Page'] = 'true'
    render :action => :waiting
  end

  # POST /Product/{1}/delete
  def delete
    @product = Product.find(@params['id'])
    @product.destroy

    # immediately send to the server and show index after sync
    Product.set_notification("/app/Product/show_index_after_sync", "do_transition=#{@request['headers']['Jqtouch']}")
    SyncEngine.dosync_source(@product.source_id)

    @response['headers']['Wait-Page'] = 'true'
    render :action => :waiting
  end

  # This is the callback method invoked after an async http request. On successful response, a JavaScript function
  # is executed to transition to that page.
  def show_callback
    if @params['status'] == 'ok'
      @product = Product.new(@params['body']['product'])
      @product.object = @product.id
      render_transition :action => :show
    else
      # In this example, an error just navigates back to the index w/o transition.
      # WebView.navigate ensures no transition occurs. An error screen could be presented to the user to
      # indicate something bad happened.
      WebView.navigate url_for :action => :index
    end

  end

  def show_index_after_sync
    @products = Product.find(:all)
    add_objectnotify(@products)
    if @params['do_transition'] == 'true'
      render_transition :action => :index
    else
      WebView.navigate url_for :action => :index
    end
  end
end
