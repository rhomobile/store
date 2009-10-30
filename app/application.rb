require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  def initialize
    # @tabs = [{ :label => "Start Page", :icon => "/public/images/tabs/home_btn.png", :action => '/app', :reload => true }, 
    #          { :label => "Options", :action => '/app/Settings', :icon => "/public/images/tabs/gears.png", :reload => true }]
    super
    
    SyncEngine::set_objectnotify_url("/app/Settings/sync_notify")
    
    # we want to be notified whenever either of these sources is synced
    Product.set_notification("/app/Settings/sync_notify", "fixed sync_notify for Product")
    Customer.set_notification("/app/Settings/sync_notify", "fixed sync_notify for Customer")
  end
end
