require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidatesFormatOfTest < Test::Unit::TestCase
  test "when attribute value does not match the given regex, then valid is false" do
    validation = Validatable::ValidatesFormatOf.new :name
    validation.with = /book/
    assert_equal false, validation.valid?(stub_everything)
  end
  
  test "when attribute value does match the given regex, then valid is true" do
    validation = Validatable::ValidatesFormatOf.new :name
    validation.with = /book/
    assert_equal true, validation.valid?(stub(:name=>"book"))
  end
end