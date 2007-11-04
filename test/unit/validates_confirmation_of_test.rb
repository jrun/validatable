require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidatesConfirmationOfTest < Test::Unit::TestCase
  test "valid confirmation" do
    validation = Validatable::ValidatesConfirmationOf.new stub_everything, :username
    instance = stub(:username=>"username", :username_confirmation=>"username")
    assert_equal true, validation.valid?(instance)
  end
  
  test "invalid confirmation" do
    validation = Validatable::ValidatesConfirmationOf.new stub_everything, :username
    instance = stub(:username=>"username", :username_confirmation=>"usessrname")
    assert_equal false, validation.valid?(instance)
  end
  
  test "valid confirmation with case insensitive" do
    validation = Validatable::ValidatesConfirmationOf.new stub_everything, :username, :case_sensitive => false
    instance = stub(:username=>"username", :username_confirmation=>"USERNAME")
    assert_equal true, validation.valid?(instance)
  end
  
  test "invalid confirmation with case sensitive" do
    validation = Validatable::ValidatesConfirmationOf.new stub_everything, :username, :case_sensitive => true
    instance = stub(:username=>"username", :username_confirmation=>"USERNAME")
    assert_equal false, validation.valid?(instance)
  end
  
  test "invalid confirmation if value is nil and confirmation is not with case sensitive true" do
    validation = Validatable::ValidatesConfirmationOf.new stub_everything, :username, :case_sensitive => true
    assert_equal false, validation.valid?(stub(:username => nil, :username_confirmation => 'something'))
  end

  test "invalid confirmation if confirmation is nil and value is not with case sensitive true" do
    validation = Validatable::ValidatesConfirmationOf.new stub_everything, :username, :case_sensitive => true
    assert_equal false, validation.valid?(stub(:username => 'something', :username_confirmation => nil))
  end

  test "valid confirmation if value and confirmation are nil with case sensitive true" do
    validation = Validatable::ValidatesConfirmationOf.new stub_everything, :username, :case_sensitive => true
    assert_equal true, validation.valid?(stub(:username => nil, :username_confirmation => nil))
  end
  
  test "invalid confirmation if value is nil and confirmation is not with case sensitive false" do
    validation = Validatable::ValidatesConfirmationOf.new stub_everything, :username, :case_sensitive => false
    assert_equal false, validation.valid?(stub(:username => nil, :username_confirmation => 'something'))
  end

  test "invalid confirmation if confirmation is nil and value is not with case sensitive false" do
    validation = Validatable::ValidatesConfirmationOf.new stub_everything, :username, :case_sensitive => false
    assert_equal false, validation.valid?(stub(:username => 'something', :username_confirmation => nil))
  end

  test "valid confirmation if value and confirmation are nil with case sensitive false" do
    validation = Validatable::ValidatesConfirmationOf.new stub_everything, :username, :case_sensitive => false
    assert_equal true, validation.valid?(stub(:username => nil, :username_confirmation => nil))
  end
  
  expect true do
    options = { :message => nil, :if => nil, :times => nil, :level => nil, :groups => nil, :case_sensitive => nil }
    Validatable::ValidatesConfirmationOf.new(stub_everything, :test).must_understand(options)
  end
  
end