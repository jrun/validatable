require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class FunctionalTest < Test::Unit::TestCase
  test "given no name, when validated, then error is in the objects error collection" do
    klass = Class.new do
      include Validatable
      attr_accessor :name
      validates_presence_of :name
    end
    instance = klass.new
    instance.valid?
    assert_equal "can't be empty", instance.errors.on(:name)
  end

  test "given invalid name format, when validated, then error is in the objects error collection" do
    klass = Class.new do
      include Validatable
      attr_accessor :name
      validates_format_of :name, :with => /.+/
    end
    instance = klass.new
    instance.valid?
    assert_equal "is invalid", instance.errors.on(:name)
  end
  
  test "given no acceptance, when validated, then error is in the objects error collection" do
    klass = Class.new do
      include Validatable
      attr_accessor :name
      validates_acceptance_of :name
    end
    instance = klass.new
    instance.valid?
    assert_equal "must be accepted", instance.errors.on(:name)
  end
  
  test "given non matching attributes, when validated, then error is in the objects error collection" do
    klass = Class.new do
      include Validatable
      attr_accessor :name, :name_confirmation
      validates_confirmation_of :name
    end
    instance = klass.new
    instance.name = "foo"
    instance.name_confirmation = "bar"
    instance.valid?
    assert_equal "doesn't match confirmation", instance.errors.on(:name)
  end

  test "given short value, when validated, then error is in the objects error collection" do
    klass = Class.new do
      include Validatable
      attr_accessor :name
      validates_length_of :name, :minimum => 2
    end
    instance = klass.new
    instance.valid?
    assert_equal "is invalid", instance.errors.on(:name)
  end
  
  test "given a child class with validations, when parent class is validated, then the error is in the parent objects error collection" do
    child_class = Class.new do
      include Validatable
      attr_accessor :name, :address
      validates_presence_of :name
      validates_format_of :address, :with => /.+/
    end
    klass = Class.new do
      include Validatable
      include_validations_for :child 
      define_method :child do
        child_class.new
      end
    end
    instance = klass.new
    instance.valid?
    assert_equal "is invalid", instance.errors.on(:address)
    assert_equal "can't be empty", instance.errors.on(:name)
  end
end