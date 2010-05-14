class Product
    include Rhom::FixedSchema

    enable :sync

    set :partition, :application
    set :source_id, 2
    set :sync_priority, 0
    #set :sync_type, :bulk_only

    property :brand, :string
    property :created_at
    property :name
    property :price
    property :quantity
    property :sku
    property :updated_at
    
    property :image_url, :blob
    
    index :brand, :price
    unique_index :name
    
    set :schema_version, '1.0'
end