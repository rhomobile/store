require 'rhom'

class Product_s
    include Rhom::FixedSchema

    enable :sync
    set :sync_priority, 2 #should sync after Customer    
    
    set :schema_version, '1.0'
    
    belongs_to :quantity, 'Customer_s'
    belongs_to :sku, 'Customer_s'
    
    property :brand, :string
    property :created_at, :string
    property :name, :string
    property :price, :string
    property :quantity, :string
    property :sku, :string
    property :updated_at,  :string
    
    enable :pass_through    

end