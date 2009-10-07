require 'rho/rhocontroller'

class ProductController < Rho::RhoController

  #GET /Product
  def index
    @products = Product.find(:all)
    add_objectnotify(@products)
    render
  end

  # GET /Product/{1}
  def show
    @product = Product.find(@params['id'])
    render :action => :show
  end

  # GET /Product/new
  def new
    @product = Product.new
    render :action => :new
  end

  # GET /Product/{1}/edit
  def edit
    @product = Product.find(@params['id'])
    if @product && !@product.can_modify
        render :action => :cannot_edit
    else    
        render :action => :edit
    end
  end

  # POST /Product/create
  def create
    @product = Product.new(@params['product'])
    if !@product.save
        render :action => :cannot_edit
    else
        redirect :action => :index
    end    
  end

  # POST /Product/{1}/update
  def update
    @product = Product.find(@params['id'])
    if !@product.update_attributes(@params['product'])
        render :action => :cannot_edit
    else
        redirect :action => :index
    end
        
  end

  # POST /Product/{1}/delete
  def delete
    @product = Product.find(@params['id'])
    if !@product.destroy
        render :action => :cannot_edit
    else
        redirect :action => :index
    end    
  end
end
