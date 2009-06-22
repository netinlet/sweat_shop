require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/sweat_shop'

class SerializerTest < Test::Unit::TestCase

  # no serializer specified
  class DefaultSerialWorker < SweatShop::Worker
    def hello(name)
      "Hi, #{name}"
    end
  end

  # Marshall specified serializer
  class MarshalWorker < SweatShop::Worker
    serialize_with :marshal
    def hello(name)
      "Hi, #{name}"
    end
  end

  # JSON specified serializer
  class JsonWorker < SweatShop::Worker
    serialize_with :json
    def hello(name)
      "Hi, #{name}"
    end
  end
  
  # YAML specified serializer
  class YamlWorker < SweatShop::Worker
    serialize_with :yaml
    def hello(name)
      "Hi, #{name}"
    end
  end
  
  class NoNameSerializer < SweatShop::Serializer
    def self.serialize(payload)
      "x"
    end
    
    def self.deserialize(payload)
      "y"
    end
  end
  
  class NamedSerializer < SweatShop::Serializer
    serializer_name :silly
    def self.serialize(payload)
      "x"
    end
    
    def self.deserialize(payload)
      "y"
    end
    
  end
    
  test "should use default serializer if none is specified" do
    assert_equal SweatShop::Serializers::MarshalSerializer, DefaultSerialWorker.serializer
  end
  
  test "should mark marshal as the default serializer out of the box" do
    assert_equal SweatShop::Serializer.default, SweatShop::Serializers::MarshalSerializer
  end
  test "should be able to specify the default serializer" do
    SweatShop::Serializer.default = :json
    assert_equal SweatShop::Serializer.default, SweatShop::Serializers::JsonSerializer
    SweatShop::Serializer.default = :marshal # set it back so tests don't break
  end
  
  test "should be able to specify json as the serializer on a per class basis" do
    assert_equal JsonWorker.serializer, SweatShop::Serializers::JsonSerializer
  end
  
  test "should be able to specify marshal as the serializer on a per class basis" do
    assert_equal MarshalWorker.serializer, SweatShop::Serializers::MarshalSerializer
  end

  test "should be able to specify yaml as the serializer on a per class basis" do
    assert_equal YamlWorker.serializer, SweatShop::Serializers::YamlSerializer
  end

  test "should provide a default short name based on class name" do
    assert_equal :no_name, NoNameSerializer.get_name
  end
  
  test "should accept a custom short name" do
    assert_equal :silly, NamedSerializer.get_name
  end
  
  test "should register all available serializers" do
    assert_equal ["json", "marshal", "no_name", "silly", "yaml"], SweatShop::Serializer.serializers.keys.map{|k| k.to_s}.sort
  end
end
