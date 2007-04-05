require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Functional
  class ValidatableTest < Test::Unit::TestCase
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
    
    test "nonmatching groups are not used as validations" do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :groups => :group_one
        attr_accessor :name
      end
      instance = klass.new
      assert_equal true, instance.valid?(:group_two)
    end
    
    test "matching groups are used as validations when multiple groups are given to valid" do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :groups => :group_one
        attr_accessor :name
      end
      instance = klass.new
      assert_equal false, instance.valid?(:group_one)
    end
    
    test "matching groups are used as validations when validations are part of multiple groups" do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :groups => [:group_one, :group_two]
        attr_accessor :name
      end
      instance = klass.new
      assert_equal false, instance.valid?(:group_one)
    end
    
    test "no group given then all validations are used" do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :groups => :group_one
        attr_accessor :name
      end
      instance = klass.new
      assert_equal false, instance.valid?
    end
    
    test "matching multiple groups for validations" do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :groups => :group_one
        validates_presence_of :address, :groups => :group_two
        attr_accessor :name, :address
      end
      instance = klass.new
      instance.valid?(:group_one, :group_two)
      assert_equal 2, instance.errors.size
    end
    
    expect true do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :times => 1
        attr_accessor :name
      end
      instance = klass.new
      instance.valid?
      instance.valid?
    end
    
    expect false do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :times => 1
        attr_accessor :name
      end
      instance1 = klass.new
      instance1.valid?
      instance2 = klass.new
      instance2.valid?
    end
    
    expect "name message" do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :level => 1, :message => "name message"
        validates_presence_of :address, :level => 2
        attr_accessor :name, :address
      end
      instance = klass.new
      instance.valid?
      instance.errors.on(:name)
    end
    
    expect nil do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :level => 1, :message => "name message"
        validates_presence_of :address, :level => 2
        attr_accessor :name, :address
      end
      instance = klass.new
      instance.valid?
      instance.errors.on(:address)
    end
  end
end