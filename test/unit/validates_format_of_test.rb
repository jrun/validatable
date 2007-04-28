require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidatesFormatOfTest < Test::Unit::TestCase
  test "when attribute value does not match the given regex, then valid is false" do
    validation = Validatable::ValidatesFormatOf.new :name, :with => /book/
    assert_equal false, validation.valid?(stub_everything)
  end
  
  test "when attribute value does match the given regex, then valid is true" do
    validation = Validatable::ValidatesFormatOf.new :name, :with => /book/
    assert_equal true, validation.valid?(stub(:name=>"book"))
  end
  
  test "when attribute value is an integer it should be converted to a string before matching" do
    validation = Validatable::ValidatesFormatOf.new :age, :with => /14/
    assert_equal true, validation.valid?(stub(:age=>14))
  end
  
  expect true do
    Validatable::ValidatesFormatOf.must_understand(:message => nil, :if => nil, :times => nil, :level => nil, :groups => nil, :with => nil)
  end
  
end