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
  
    test "valid length" do
      validation = Validatable::ValidatesLengthOf.new :username
      validation.minimum = 2
      validation.maximum = 8
      instance = stub(:username=>"udfgdf")
      assert_equal true, validation.valid?(instance)
    end
  end
end