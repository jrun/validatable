require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Unit
  class ValidatesLengthOfTest < Test::Unit::TestCase
  
    test "max length" do
      validation = Validatable::ValidatesLengthOf.new :username
      validation.maximum = 8
      instance = stub(:username=>"usernamefdfd")
      assert_equal false, validation.valid?(instance)
    end
    
    test "min length" do
      validation = Validatable::ValidatesLengthOf.new :username
      validation.minimum = 2
      instance = stub(:username=>"u")
      assert_equal false, validation.valid?(instance)
    end
  
    test "is length is false" do
      validation = Validatable::ValidatesLengthOf.new :username
      validation.is = 2
      instance = stub(:username=>"u")
      assert_equal false, validation.valid?(instance)
    end
    
    test "is length is true" do
      validation = Validatable::ValidatesLengthOf.new :username
      validation.is = 2
      instance = stub(:username=>"uu")
      assert_equal true, validation.valid?(instance)
    end
    
    test "valid length" do
      validation = Validatable::ValidatesLengthOf.new :username
      validation.minimum = 2
      validation.maximum = 8
      instance = stub(:username=>"udfgdf")
      assert_equal true, validation.valid?(instance)
    end
    
    expect true do
      options = {:message => nil, :if => nil, :times => nil, :level => nil, :groups => nil, :maximum => nil, :minimum => nil, :is => nil}
      Validatable::ValidatesLengthOf.must_understand(options)
    end
    
  end
end