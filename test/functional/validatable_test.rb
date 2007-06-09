require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Functional
  class ValidatableTest < Test::Unit::TestCase 
    
    expect ArgumentError do
      Class.new do
        include Validatable
        attr_accessor :name
        validates_presence_of :name, :times => 1
        validates_presence_of :name, :times => 1
      end
    end
    
    expect ArgumentError do
      Class.new do
        include Validatable
        attr_accessor :name
        validates_presence_of :name, :times => 1, :key => 'anything'
        validates_presence_of :name, :times => 1, :key => 'anything'
      end
    end
    
    expect "is invalid" do
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
      instance.errors.on(:address)
    end
    
    expect "can't be empty" do
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
      instance.errors.on(:name)
    end
    
    
    test "when child validations have errors, level 2 and higher parent validations are not performed" do
      child_class = Class.new do
        include Validatable
        attr_accessor :name
        validates_presence_of :name
      end
      
      klass = Class.new do
        include Validatable
        extend Forwardable
        def_delegator :child, :name
        validates_true_for :name, :logic => lambda { false }, :level => 2, :message => "invalid message"
        include_validations_for :child 
        define_method :child do
          @child ||= child_class.new
        end
      end
      instance = klass.new
      instance.valid?
      assert_equal "can't be empty", instance.errors.on(:name)
    end
  
   test "when child validations have errors, level 1 parent validations are still performed" do
      child_class = Class.new do
        include Validatable
        attr_accessor :name
        validates_presence_of :name
      end

      klass = Class.new do
        include Validatable
        validates_true_for :address, :logic => lambda { false }, :level => 1, :message => "invalid message"
        include_validations_for :child 
        define_method :child do
          @child ||= child_class.new
        end

      end
      instance = klass.new
      instance.valid?
      assert_equal "can't be empty", instance.errors.on(:name)
      assert_equal "invalid message", instance.errors.on(:address)
    end
  
    expect "can't be empty" do
      child_class = Class.new do
        include Validatable
        attr_accessor :name, :address
        validates_presence_of :name
      end
      klass = Class.new do
        include Validatable
        include_validations_for :child, :map => {:name => :namen}
        define_method :child do
          child_class.new
        end
      end
      instance = klass.new
      instance.valid?
      instance.errors.on(:namen)
    end
    
    expect "can't be empty" do
      child_class = Class.new do
        include Validatable
        attr_accessor :name, :address
        validates_presence_of :name
      end
      klass = Class.new do
        include Validatable
        include_validations_for :child, :if => lambda { true }
        define_method :child do
          child_class.new
        end
      end
      instance = klass.new
      instance.valid?
      instance.errors.on(:name)
    end
    
    expect true do
      child_class = Class.new do
        include Validatable
        attr_accessor :name, :address
        validates_presence_of :name
      end
      klass = Class.new do
        include Validatable
        include_validations_for :child, :if => lambda { false }
        define_method :child do
          child_class.new
        end
      end
      instance = klass.new
      instance.valid?
    end
    
    test "classes only have valid_for_* methods for groups that appear in their validations" do
      class_with_group_one = Class.new do
        include Validatable
        validates_presence_of :name, :groups => :group_one
        attr_accessor :name
      end
      class_with_group_two = Class.new do
        include Validatable
        validates_presence_of :name, :groups => :group_two
        attr_accessor :name
      end
      assert_equal false, class_with_group_one.public_instance_methods.include?(:valid_for_group_two?)
      assert_equal false, class_with_group_two.public_instance_methods.include?(:valid_for_group_one?)
    end
    
    test "nonmatching groups are not used as validations" do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :groups => :group_one
        validates_presence_of :address, :groups => :group_two
        attr_accessor :name, :address
      end
      instance = klass.new
      assert_equal nil, instance.errors.on(:name)
    end
    
    expect "can't be empty twice changed message" do
      klass = Class.new do
        include Validatable
        validates_presence_of :name
        attr_accessor :name
      end
      
      Validatable::ValidationBase.class_eval do
        after_validate do |result, instance, attribute|
          instance.errors.add(attribute, " changed message")
        end
      end
      Validatable::ValidatesPresenceOf.class_eval do
        after_validate do |result, instance, attribute|
          instance.errors.add(attribute, " twice")
        end
      end
      instance = klass.new
      instance.valid?
      Validatable::ValidatesPresenceOf.after_validations.clear
      Validatable::ValidationBase.after_validations.clear
      instance.errors.on(:name).join
    end

    expect false do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :groups => :group_one
        attr_accessor :name
      end
      instance = klass.new
      instance.valid_for_group_one?
    end
    
    expect false do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :groups => [:group_one, :group_two]
        attr_accessor :name
      end
      instance = klass.new
      instance.valid_for_group_one?
    end
    
    expect true do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :groups => :group_one
        validates_presence_of :address
        attr_accessor :name, :address
      end
      instance = klass.new
      instance.address = 'anything'
      instance.valid?
    end
    
    expect true do
      klass = Class.new do
        include Validatable
        validates_presence_of :name, :groups => :group_one
        attr_accessor :name
      end
      instance = klass.new
      instance.valid?
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