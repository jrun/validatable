module Validatable
  module ClassMethods
    def validates_format_of(*args)
      validate_all(args) do |attribute, options|
        self.validations << ValidatesFormatOf.new(attribute, options[:with], options[:message] || "is invalid")
      end
    end
  
    def validates_presence_of(*args)
      validate_all(args) do |attribute, options|
        self.validations << ValidatesPresenceOf.new(attribute, options[:message] || "can't be empty")
      end
    end
    
    def include_validations_for(*args)
      children_to_validate.concat args
    end
    
    def children_to_validate
      @children_to_validate ||= []
    end
    
    def validate_all(args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      args.each do |attribute|
        yield attribute, options
      end
    end
    protected :validate_all
    
    def validations
      @validations ||= []
    end
  
    def validate(instance)
      self.validations.each do |validation|
        instance.errors.add(validation.attribute, validation.message) unless validation.valid?(instance)
      end
      instance.errors.empty?
    end
    
    def validate_children(instance)
      self.children_to_validate.each do |child_name|
        child = instance.send child_name
        child.valid?
        child.errors.each do |attribute, message|
          instance.errors.add(attribute, message)
        end
      end
    end
  end
  
  def self.included(klass)
    klass.extend Validatable::ClassMethods
  end
  
  def valid?
    errors.clear
    self.class.validate(self)
    self.class.validate_children(self)
    errors.empty?
  end
  
  def errors
    @errors ||= Validatable::Errors.new
  end
end