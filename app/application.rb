require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    # Super must be called *after* settings @tabs!
    @tabs = nil
    @@tabbar = nil

    super

    SyncEngine::set_objectnotify_url("/app/Settings/sync_object_notify")
    
    # we want to be notified whenever either of these sources is synced
    SyncEngine.set_notification(-1, "/app/Settings/sync_notify", '')
    SyncEngine.enable_status_popup(false)
    
  end
  
  def on_activate_app
    puts "on_activate_app"
  end
  
end
