require 'rho/rhocontroller'

class CustomerController < Rho::RhoController

  #GET /Customer
  def index
    @customers = Customer.find(:all)
    render
  end

  # GET /Customer/{1}
  def show
    @customer = Customer.find(@params['id'])
    render :action => :show
  end

  # GET /Customer/new
  def new
    @customer = Customer.new
    render :action => :new
  end

  # GET /Customer/{1}/edit
  def edit
    @customer = Customer.find(@params['id'])
    render :action => :edit
  end

  # POST /Customer/create
  def create
    @customer = Customer.new(@params['customer'])
    @customer.save
    
    # immediately send to the server
		SyncEngine::dosync(false)
	
    redirect :action => :index
  end

  # POST /Customer/{1}/update
  def update
    @customer = Customer.find(@params['id'])
    @customer.update_attributes(@params['customer'])
    
    # immediately send to the server
		SyncEngine::dosync(false)
		
    redirect :action => :index
  end

  # POST /Customer/{1}/delete
  def delete
    @customer = Customer.find(@params['id'])
    @customer.destroy
    
    # immediately send to the server
		SyncEngine::dosync(false)
    redirect :action => :index
  end
end
