# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class Customer
  include Rho::ORM::PropertyBag
  enable :sync
end
