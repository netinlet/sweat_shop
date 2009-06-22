gem 'json'
require 'json'
require 'json/add/rails'
require 'json/add/core'

module SweatShop
  module Serializers
    class JsonSerializer < SweatShop::Serializer
      class << self
      
        def serialize(payload)
          if payload.respond_to?(:to_json)
            payload.to_json
          else
            JSON.generate(payload)
          end
        end
      
        def deserialize(payload)
          JSON.parse(payload)
        end
      end
    end
  end
end