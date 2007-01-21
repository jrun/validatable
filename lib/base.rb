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
  end
  
  def self.included(klass)
    klass.extend Validatable::ClassMethods
  end
  
  def valid?
    self.class.validate(self)
  end
  
  def errors
    @errors ||= Validatable::Errors.new
  end
end