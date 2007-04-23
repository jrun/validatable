require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidatesConfirmationOfTest < Test::Unit::TestCase
  test "valid confirmation" do
    validation = Validatable::ValidatesConfirmationOf.new :username
    instance = stub(:username=>"username", :username_confirmation=>"username")
    assert_equal true, validation.valid?(instance)
  end
  
  test "invalid confirmation" do
    validation = Validatable::ValidatesConfirmationOf.new :username
    instance = stub(:username=>"username", :username_confirmation=>"usessrname")
    assert_equal false, validation.valid?(instance)
  end
  
  test "valid confirmation with case insensitive" do
    validation = Validatable::ValidatesConfirmationOf.new :username
    validation.case_sensitive = false
    instance = stub(:username=>"username", :username_confirmation=>"USERNAME")
    assert_equal true, validation.valid?(instance)
  end
  
  test "invalid confirmation with case sensitive" do
    validation = Validatable::ValidatesConfirmationOf.new :username
    validation.case_sensitive = true
    instance = stub(:username=>"username", :username_confirmation=>"USERNAME")
    assert_equal false, validation.valid?(instance)
  end
end