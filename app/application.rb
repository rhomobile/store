require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  def initialize
    # @tabs = [{ :label => "Start Page", :icon => "/public/images/tabs/home_btn.png", :action => '/app', :reload => true }, 
    #          { :label => "Options", :action => '/app/Settings', :icon => "/public/images/tabs/gears.png", :reload => true }]
    super
  end
end
