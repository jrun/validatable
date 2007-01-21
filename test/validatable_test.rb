require 'test_helper'

class ValidatableTest < Test::Unit::TestCase
  test "given no presence when object is validated then valid returns false" do
    klass = Class.new
    klass.class_eval do
      include Validatable
      attr_accessor :name
      validates_presence_of :name
    end
    
    assert_equal false, klass.new.valid?
  end

  test "given no presence when object is validated then it contains errors" do
    klass = Class.new
    klass.class_eval do
      include Validatable
      attr_accessor :name
      validates_presence_of :name
    end
    instance = klass.new
    instance.valid?
    assert_equal "can't be empty", instance.errors.on(:name)
  end
  
  test "given invalid format when object is validated then valid returns false" do
    klass = Class.new
    klass.class_eval do
      include Validatable
      attr_accessor :name
      validates_format_of :name, :with=>/.+/
    end
    
    assert_equal false, klass.new.valid?
  end

  test "given invalid format when object is validated then it contain errors" do
    klass = Class.new
    klass.class_eval do
      include Validatable
      attr_accessor :name
      validates_format_of :name, :with=>/.+/
    end
    instance = klass.new
    instance.valid?
    assert_equal "is invalid", instance.errors.on(:name)
  end
end