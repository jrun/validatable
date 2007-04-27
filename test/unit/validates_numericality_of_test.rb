require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Unit
  class ValidatesNumericalityOfTest < Test::Unit::TestCase
 
    test "when the value is  nil then valid is false" do
      validation = Validatable::ValidatesNumericalityOf.new :nothing
      instance = stub(:nothing => nil)
      assert_equal false, validation.valid?(instance)
    end
  
    test "when value is an integer then valid is true" do
      validation = Validatable::ValidatesNumericalityOf.new :some_int
      instance = stub(:some_int => 50)
      assert_equal true, validation.valid?(instance)
    end  
   
    test "when value is an decimal then valid is true" do
      validation = Validatable::ValidatesNumericalityOf.new :some_decimal
      instance = stub(:some_decimal => 1.23)
      assert_equal true, validation.valid?(instance)
    end
  
    test "when value has non numeric characters then valid is false" do
      validation = Validatable::ValidatesNumericalityOf.new :some_non_numeric
      instance = stub(:some_non_numeric => "50F")
      assert_equal false, validation.valid?(instance)
    end
  
    test "when value is a string with multiple dots then valid is false" do
      validation = Validatable::ValidatesNumericalityOf.new :multiple_dots
      instance = stub(:multiple_dots => "50.0.0")
      assert_equal false, validation.valid?(instance)
    end
    
    expect true do
      Validatable::ValidatesNumericalityOf.must_understand(:message => nil, :if => nil, :times => nil, :level => nil, :groups => nil)
    end
    
  end
end