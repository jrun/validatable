require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Unit
  class ValidatesLengthOfTest < Test::Unit::TestCase
    expect false do
      validation = Validatable::ValidatesLengthOf.new stub_everything, :username, :maximum => 8
      validation.valid?(stub(:username=>"usernamefdfd"))
    end
    
    test "min length" do
      validation = Validatable::ValidatesLengthOf.new stub_everything, :username, :minimum => 2
      instance = stub(:username=>"u")
      assert_equal false, validation.valid?(instance)
    end
  
    test "valid length" do
      validation = Validatable::ValidatesLengthOf.new stub_everything, :username, :minimum => 2, :maximum => 8
      instance = stub(:username=>"udfgdf")
      assert_equal true, validation.valid?(instance)
    end
    
    test "is length is false" do
      validation = Validatable::ValidatesLengthOf.new stub_everything, :username, :is => 2
      instance = stub(:username=>"u")
      assert_equal false, validation.valid?(instance)
    end
    
    test "is length is true" do
      validation = Validatable::ValidatesLengthOf.new stub_everything, :username, :is => 2
      instance = stub(:username=>"uu")
      assert_equal true, validation.valid?(instance)
    end
    
    test "within lower bound is true" do
      validation = Validatable::ValidatesLengthOf.new stub_everything, :username, :within => 2..4
      instance = stub(:username => "aa")
      assert_equal true, validation.valid?(instance)
    end

    test "within outside lower bound is false" do
      validation = Validatable::ValidatesLengthOf.new stub_everything, :username, :within => 2..4
      instance = stub(:username => "a")
      assert_equal false, validation.valid?(instance)
    end

    test "within upper bound is true" do
      validation = Validatable::ValidatesLengthOf.new stub_everything, :username, :within => 2..4
      instance = stub(:username => "aaaa")
      assert_equal true, validation.valid?(instance)
    end

    test "within outside upper bound is false" do
      validation = Validatable::ValidatesLengthOf.new stub_everything, :username, :within => 2..4
      instance = stub(:username => "aaaaa")
      assert_equal false, validation.valid?(instance)
    end

    test "given nil value, should not be valid" do
      validation = Validatable::ValidatesLengthOf.new stub_everything, :username, :within => 2..4
      instance = stub(:username => nil)
      assert_equal false, validation.valid?(instance)
    end


    test "given allow_nil is true, nil value should be valid" do
      validation = Validatable::ValidatesLengthOf.new stub_everything, :username, :within => 2..4, :allow_nil => true
      instance = stub(:username => nil)
      assert_equal true, validation.valid?(instance)
    end
    
    expect true do
      options = [:message, :if, :times, :level, :groups, :maximum, :minimum, :is, :within, :allow_nil]
      Validatable::ValidatesLengthOf.new(stub_everything, :test).must_understand(options.to_blank_options_hash)
    end
    
  end
end