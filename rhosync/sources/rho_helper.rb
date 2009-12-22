module RhoHelper
  module ClassMethods
    # Receives an array of AR Objects and returns a hash of hashes with each
    # item being like: { "id" => { 'attribute_1' => value_1 } }
    def hashinate(result)
      hash = {}
      result.each do |p|
        attrs = p.attributes.reject { |key, value| value.is_a? Time }
        hash[p.id.to_s] = attrs
      end
      hash
    end

    def hashinate_all
      hash = hashinate(find(:all))
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
  end
end