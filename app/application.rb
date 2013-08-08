require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    # Super must be called *after* settings @tabs!
    @tabs = nil
    @@tabbar = nil

    super

    Rho::RhoConnectClient.setObjectNotification("/app/Settings/sync_object_notify")
    
    # we want to be notified whenever either of these sources is synced
    Rho::RhoConnectClient.setNotification('*', "/app/Settings/sync_notify", '')
    Rho::RhoConnectClient.showStatusPopup = false

  end
  
  def on_activate_app
    puts "on_activate_app"
  end
  
end
