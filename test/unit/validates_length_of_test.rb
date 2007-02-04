require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidatesLengthOfTest < Test::Unit::TestCase
  
  test "max length" do
    validation = Validatable::ValidatesLengthOf.new(:username,  nil, 8, :message)
    instance = stub(:username=>"usernamefdfd")
    assert_equal false, validation.valid?(instance)
  end
    
  test "min length" do
    validation = Validatable::ValidatesLengthOf.new(:username,  2, nil, :message)
    instance = stub(:username=>"u")
    assert_equal false, validation.valid?(instance)
  end
  
  test "valid length" do
    validation = Validatable::ValidatesLengthOf.new(:username,  2, 8, :message)
    instance = stub(:username=>"udfgdf")
    assert_equal true, validation.valid?(instance)
  end
end

