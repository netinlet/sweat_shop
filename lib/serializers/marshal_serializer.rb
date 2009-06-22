module SweatShop
  module Serializers
    class MarshalSerializer < SweatShop::Serializer
      class << self
        def serialize(payload)
          Marshal.dump(payload)
        end
      
        def deserialize(payload)
          Marshal.load(payload)
        end
      end
    end
  end
end