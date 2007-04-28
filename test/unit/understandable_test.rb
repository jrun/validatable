require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class UnderstandableTest < Test::Unit::TestCase
  test "all understandings should collect understandings from all super classes" do
    a = Class.new do
      extend Validatable::Understandable
      understands :a
    end
    
    b = Class.new(a) do
      extend Validatable::Understandable
      understands :b
    end
    c = Class.new(b) do
      extend Validatable::Understandable
      understands :c
    end
    
    assert_array_equal [:a, :b, :c], c.all_understandings
  end
end
