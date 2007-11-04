require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidatesPresenceOfTest < Test::Unit::TestCase
  test "when attribute value does not match the given regex, then valid is false" do
    validation = Validatable::ValidatesPresenceOf.new stub_everything, :name
    assert_equal false, validation.valid?(stub_everything)
  end
  
  test "when attribute value does match the given regex, then valid is true" do
    validation = Validatable::ValidatesPresenceOf.new stub_everything, :name
    assert_equal true, validation.valid?(stub(:name=>"book"))
  end
  
  test "when given a true value which is not a String, then valid is true" do 
    validation = Validatable::ValidatesPresenceOf.new stub_everything, :employee
    assert_equal true, validation.valid?(stub(:employee => stub(:nil? => false)))
  end
  
  expect true do
    options = {:message => nil, :if => nil, :times => nil, :level => nil, :groups => nil}
    Validatable::ValidatesPresenceOf.new(stub_everything, :test).must_understand(options)
  end
  
end