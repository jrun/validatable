require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidatesTrueForTest < Test::Unit::TestCase
  test "when block returns false for attribute value, then valid is false" do
    validation = Validatable::ValidatesTrueFor.new :name
    validation.logic = lambda { false }
    assert_equal false, validation.valid?(stub_everything)
  end
  
  test "when block returns true for attribute value, then valid is false" do
    validation = Validatable::ValidatesTrueFor.new :name
    validation.logic = lambda { true }
    assert_equal true, validation.valid?(stub_everything)
  end
  
end