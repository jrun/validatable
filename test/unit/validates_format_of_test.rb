require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidatesFormatOfTest < Test::Unit::TestCase
  test "when attribute value does not match the given regex, then valid is false" do
    validation = Validatable::ValidatesFormatOf.new stub_everything, :name, :with => /book/
    assert_equal false, validation.valid?(stub_everything)
  end
  
  test "when attribute value does match the given regex, then valid is true" do
    validation = Validatable::ValidatesFormatOf.new stub_everything, :name, :with => /book/
    assert_equal true, validation.valid?(stub(:name=>"book"))
  end
  
  test "when attribute value is an integer it should be converted to a string before matching" do
    validation = Validatable::ValidatesFormatOf.new stub_everything, :age, :with => /14/
    assert_equal true, validation.valid?(stub(:age=>14))
  end
  
  test "when no with is given, then an error is raised during construction" do
    assert_raises ArgumentError do
      validation = Validatable::ValidatesFormatOf.new stub_everything, :age
    end
  end
  
  expect true do
    options = [:message, :if, :times, :level, :groups, :with, :key]
    Validatable::ValidatesFormatOf.new(stub_everything, :test, options.to_blank_options_hash).must_understand(options.to_blank_options_hash)
  end
  
  expect true do
    options = [:with]
    Validatable::ValidatesFormatOf.new(stub_everything, :name, options.to_blank_options_hash).requires(options.to_blank_options_hash)
  end
  
end