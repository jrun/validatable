require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Unit
  class ValidatesNumericalityOfTest < Test::Unit::TestCase
 
    test "when the value is  nil then valid is false" do
      validation = Validatable::ValidatesNumericalityOf.new stub_everything, :nothing
      instance = stub(:nothing => nil)
      assert_equal false, validation.valid?(instance)
    end
  
    test "when value is an integer then valid is true" do
      validation = Validatable::ValidatesNumericalityOf.new stub_everything, :some_int
      instance = stub(:some_int => 50)
      assert_equal true, validation.valid?(instance)
    end  
   
    test "when value is an decimal then valid is true" do
      validation = Validatable::ValidatesNumericalityOf.new stub_everything, :some_decimal
      instance = stub(:some_decimal => 1.23)
      assert_equal true, validation.valid?(instance)
    end
  
    test "when value is a decimal but only_integer is true, then valid is false" do
      validation = Validatable::ValidatesNumericalityOf.new stub_everything, :some_decimal, :only_integer => true
      instance = stub(:some_decimal => 1.23)
      assert_equal false, validation.valid?(instance)
    end
    
    test "when value is an integer string and only_integer is true, then valid is true" do
      validation = Validatable::ValidatesNumericalityOf.new stub_everything, :some_negative_number, :only_integer => true
      instance = stub(:some_negative_number => "-1")
      assert_equal true, validation.valid?(instance)
    end
    
    test "when value has non numeric characters then valid is false" do
      validation = Validatable::ValidatesNumericalityOf.new stub_everything, :some_non_numeric
      instance = stub(:some_non_numeric => "50F")
      assert_equal false, validation.valid?(instance)
    end
  
    test "when value is a string with multiple dots then valid is false" do
      validation = Validatable::ValidatesNumericalityOf.new stub_everything, :multiple_dots
      instance = stub(:multiple_dots => "50.0.0")
      assert_equal false, validation.valid?(instance)
    end
    
    expect true do
      options = [:message, :if, :times, :level, :groups, :only_integer]
      Validatable::ValidatesNumericalityOf.new(stub_everything, :test).must_understand(options.to_blank_options_hash)
    end
    
  end
end