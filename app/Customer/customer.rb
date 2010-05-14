require 'rhom'

class Customer
    include Rhom::PropertyBag

    enable :sync

    set :partition, :application
    set :source_id, 1
    set :sync_priority, 1
    #set :sync_type, :bulk_only
    
    belongs_to :product_id, 'Product'

    property :image_url, :blob

end