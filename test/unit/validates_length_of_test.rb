require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Unit
  class ValidatesLengthOfTest < Test::Unit::TestCase
    test "max length" do
      validation = Validatable::ValidatesLengthOf.new :username, :maximum => 8
      instance = stub(:username=>"usernamefdfd")
      assert_equal false, validation.valid?(instance)
    end
    
    test "min length" do
      validation = Validatable::ValidatesLengthOf.new :username, :minimum => 2
      instance = stub(:username=>"u")
      assert_equal false, validation.valid?(instance)
    end
  
    test "valid length" do
      validation = Validatable::ValidatesLengthOf.new :username, :minimum => 2, :maximum => 8
      instance = stub(:username=>"udfgdf")
      assert_equal true, validation.valid?(instance)
    end
    
    test "is length is false" do
      validation = Validatable::ValidatesLengthOf.new :username, :is => 2
      instance = stub(:username=>"u")
      assert_equal false, validation.valid?(instance)
    end
    
    test "is length is true" do
      validation = Validatable::ValidatesLengthOf.new :username, :is => 2
      instance = stub(:username=>"uu")
      assert_equal true, validation.valid?(instance)
    end
    
    test "within lower bound is true" do
      validation = Validatable::ValidatesLengthOf.new :username, :within => 2..4
      instance = stub(:username => "aa")
      assert_equal true, validation.valid?(instance)
    end

    test "within outside lower bound is false" do
      validation = Validatable::ValidatesLengthOf.new :username, :within => 2..4
      instance = stub(:username => "a")
      assert_equal false, validation.valid?(instance)
    end

    test "within upper bound is true" do
      validation = Validatable::ValidatesLengthOf.new :username, :within => 2..4
      instance = stub(:username => "aaaa")
      assert_equal true, validation.valid?(instance)
    end

    test "within outside upper bound is false" do
      validation = Validatable::ValidatesLengthOf.new :username, :within => 2..4
      instance = stub(:username => "aaaaa")
      assert_equal false, validation.valid?(instance)
    end

    expect true do
      options = [:message, :if, :times, :level, :groups, :maximum, :minimum, :is, :within]
      Validatable::ValidatesLengthOf.new(:test).must_understand(options.to_blank_options_hash)
    end
    
  end
end