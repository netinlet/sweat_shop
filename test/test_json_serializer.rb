require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/sweat_shop'

class JsonSerializerTest < Test::Unit::TestCase
  class UnderTest
    attr_accessor :name, :address, :city, :state, :zip, :id
    def ==(other)
      ![:name, :address, :city, :state, :zip, :id].map{|a| return self.send(a) == other.send(a)}.include?(false)
    end
    
    def self.json_create(params)
      obj = new
      for key, value in params
        next if key == 'json_class'
        obj.instance_variable_set "@#{key}", value
      end
      obj
    end
  end

  def setup
    @under_test = UnderTest.new
    @under_test.id = 87
    @under_test.name = "JsonTest"
    @under_test.address = "555 Rock Ridge Road"
    @under_test.city = "Rock Ridge"
    @under_test.state = "Texas"
    @under_test.zip = "90210"
  end
  
  test "should properly serialize a simple data structure" do
    dump = SweatShop::Serializers::JsonSerializer.serialize([{:foo => "bar"}, 23, 87, %w{doug cathy connor tommy}])
    assert_equal '[{"foo":"bar"},23,87,["doug","cathy","connor","tommy"]]', dump
  end

  
  test "should be able to serialize an arbitrary class" do
    dump = SweatShop::Serializers::JsonSerializer.serialize(@under_test)
    assert_equal @under_test, JSON.parse(dump)  # deserialize the dump because hash keys are getting set in different order from time to time & making tests fail
  end
  
  test "should be able to deserialize a simple data structure" do
    assert_equal [{"foo" => "bar"}, 23, 87, %w{doug cathy connor tommy}], SweatShop::Serializers::JsonSerializer.deserialize('[{"foo":"bar"},23,87,["doug","cathy","connor","tommy"]]')
  end
  
  test "should be able to deserialize an arbitrary class" do
    assert_equal @under_test, SweatShop::Serializers::JsonSerializer.deserialize('{"city":"Rock Ridge","name":"JsonTest","zip":"90210","json_class":"JsonSerializerTest::UnderTest","id":87,"address":"555 Rock Ridge Road","state":"Texas"}')
  end

end
