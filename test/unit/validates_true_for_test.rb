require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidatesTrueForTest < Test::Unit::TestCase
  test "when block returns false for attribute value, then valid is false" do
    validation = Validatable::ValidatesTrueFor.new stub_everything, :name, :logic => lambda { false }
    assert_equal false, validation.valid?(stub_everything)
  end
  
  test "when block returns true for attribute value, then valid is false" do
    validation = Validatable::ValidatesTrueFor.new stub_everything, :name, :logic => lambda { true }
    assert_equal true, validation.valid?(stub_everything)
  end
  
  test "when no logic is given, then an error is raised during construction" do
    assert_raises ArgumentError do
      validation = Validatable::ValidatesTrueFor.new stub_everything, :age
    end
  end
  
  expect true do
    options = [:message, :if, :times, :level, :groups, :logic, :key]
    Validatable::ValidatesTrueFor.new(stub_everything, :name, options.to_blank_options_hash).must_understand(options.to_blank_options_hash)
  end
  
  expect true do
    options = [:logic]
    Validatable::ValidatesTrueFor.new(stub_everything, :name, options.to_blank_options_hash).requires(options.to_blank_options_hash)
  end
  
end