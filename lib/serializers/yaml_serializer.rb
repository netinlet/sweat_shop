require 'yaml'

module SweatShop
  module Serializers
    class YamlSerializer < SweatShop::Serializer
      class << self
      
        def serialize(payload)
          if payload.respond_to?(:to_yaml)
            payload.to_yaml
          else
            YAML.dump(payload)
          end
        end
      
        def deserialize(payload)
          YAML.load(payload)
        end
      end
    end
  end
end