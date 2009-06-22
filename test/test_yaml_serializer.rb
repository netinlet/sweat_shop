require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/sweat_shop'

class YamlSerializerTest < Test::Unit::TestCase

  class UnderTest
    attr_accessor :name, :address, :city, :state, :zip, :id
    def ==(other)
      ![:name, :address, :city, :state, :zip, :id].map{|a| return self.send(a) == other.send(a)}.include?(false)
    end
    
  end

  def setup
    @under_test = UnderTest.new
    @under_test.id = 87
    @under_test.name = "YamlTest"
    @under_test.address = "555 Rock Ridge Road"
    @under_test.city = "Rock Ridge"
    @under_test.state = "Texas"
    @under_test.zip = "90210"
  end
  
  test "should properly serialize a simple data structure" do
    dump = SweatShop::Serializers::YamlSerializer.serialize([{:foo => "bar"}, 23, 87, %w{doug cathy connor tommy}])
    assert_equal [{:foo => "bar"}, 23, 87, %w{doug cathy connor tommy}].to_yaml, dump
  end

  
  test "should be able to serialize an arbitrary class" do
    dump = SweatShop::Serializers::YamlSerializer.serialize(@under_test)
    assert_equal @under_test.to_yaml, dump
  end
  
  test "should be able to deserialize a simple data structure" do
    assert_equal [{:foo => "bar"}, 23, 87, %w{doug cathy connor tommy}], SweatShop::Serializers::YamlSerializer.deserialize("--- \n- :foo: bar\n- 23\n- 87\n- - doug\n  - cathy\n  - connor\n  - tommy\n")
  end
  
  test "should be able to deserialize an arbitrary class" do
    assert_equal @under_test, SweatShop::Serializers::YamlSerializer.deserialize(@under_test.to_yaml)
  end


end
