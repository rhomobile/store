require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'

class CustomerController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper

  #GET /Customer
  def index
    @customers = Customer.find(:all)
    render
  end

  # GET /Customer/{1}
  def show
    @customer = Customer.find(@params['id'])
    puts "@customer : #{@customer}"
    if @customer
      render :action => :show
    else
      redirect :action => :index
    end
  end

  # GET /Customer/new
  def new
    @customer = Customer.new
    render :action => :new
  end

  # GET /Customer/{1}/edit
  def edit
    @customer = Customer.find(@params['id'])
    if @customer
      render :action => :edit
    else
      redirect :action => :index
    end
  end

  # POST /Customer/create
  def create
    @customer = Customer.new(@params['customer'])
    @customer.save

    # immediately send to the server
    Rho::RhoConnectClient.doSyncSource('Customer')

    redirect :action => :index
  end

  # POST /Customer/{1}/update
  def update
    @customer = Customer.find(@params['id'])
    @customer.update_attributes(@params['customer'])

    # immediately send to the server
    Rho::RhoConnectClient.doSync(false)

    redirect :action => :index
  end

  # POST /Customer/{1}/delete
  def delete
    @customer = Customer.find(@params['id'])
    @customer.destroy

    # immediately send to the server
    Rho::RhoConnectClient.doSync(false)
    redirect :action => :index
  end

  def search
    Customer.search(:from => 'search',
                    :search_params => {:first => @params['query']},
                    :callback => '/app/Customer/search_callback',
                    :callback_param => "first=#{@params['query']}")
    @response['headers']['Wait-Page'] = 'true'
    render :action => :searching
  end

  def search_callback
    if @params['status'] == 'complete'
      if Rho.support_transitions?() #TODO: find new api method
        @customers = Customer.find(:all, :conditions => {:first => @params['first']})
        render_transition :action => :search
      else
        Rho::WebView.navigate url_for :action => :index
      end
    else
      Rho::WebView.navigate url_for :action => :index
    end
  end

end
