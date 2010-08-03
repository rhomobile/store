require 'rho/rhocontroller'
require 'helpers/browser_helper'

class CustomerController < Rho::RhoController
  include BrowserHelper

  #GET /Customer
  def index
    @customers = Customer.find(:all)
    render
  end

  # GET /Customer/{1}
  def show
    @customer = Customer.find(@params['id'])
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
    @customer = Customer.create(@params['customer'])
    redirect :action => :index
  end

  # POST /Customer/{1}/update
  def update
    @customer = Customer.find(@params['id'])
    @customer.update_attributes(@params['customer']) if @customer
    redirect :action => :index
  end

  # POST /Customer/{1}/delete
  def delete
    @customer = Customer.find(@params['id'])
    @customer.destroy if @customer
    redirect :action => :index
  end
end
