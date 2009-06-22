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
          symbolize_keys(JSON.parse(payload))
        end
        
        protected 
        # another straight out of rails land - ActiveSupport::CoreExtensions::Hash::Keys
        def symbolize_keys(data)
          if data.is_a?(Hash)
            data.inject({}) do |options, (key, value)|
              options[(key.to_sym rescue key) || key] = value
              options
            end
          else
            data
          end
        end
        
      end
    end
  end
end