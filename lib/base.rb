module Validatable
  module ClassMethods
    # call-seq: validates_format_of(*args)
    # 
    # Validates whether the value of the specified attribute is of the correct form by matching it against the regular expression provided.
    # 
    #   class Person < ActiveRecord::Base
    #     validates_format_of :first_name, :with => /[ A-Za-z]/
    #   end
    # 
    # A regular expression must be provided or else an exception will be raised.
    def validates_format_of(*args)
      validate_all(args) do |attribute, message, options|
        self.validations << ValidatesFormatOf.new(attribute, options[:with], message || "is invalid")
      end
    end
    
    def validates_length_of(*args)
      validate_all(args) do |attribute, message, options|
        self.validations << ValidatesLengthOf.new(attribute, options[:minimum], options[:maximum], message || "is invalid")
      end
    end
    
    def validates_acceptance_of(*args)
      validate_all(args) do |attribute, message, options|
        self.validations << ValidatesAcceptanceOf.new(attribute, message || "must be accepted")
      end
    end

    def validates_confirmation_of(*args)
      validate_all(args) do |attribute, message, options|
        self.validations << ValidatesConfirmationOf.new(attribute, message || "doesn't match confirmation")
      end
    end

  
    # call-seq: validates_presence_of(*args)
    # 
    # Validates that the specified attributes are not nil or an empty string
    # 
    #   class Person
    #     include Validatable
    #     validates_presence_of :first_name
    #   end
    #
    # The first_name attribute must be in the object and it cannot be nil or empty.
    def validates_presence_of(*args)
      validate_all(args) do |attribute, message, options|
        self.validations << ValidatesPresenceOf.new(attribute, message || "can't be empty")
      end
    end
    
    # call-seq: include_validations_for(*args)
    # 
    # Validates the specified attributes.
    # 
    #   class PersonPresenter
    #     include Validatable
    #     include_validations_for :person
    #     attr_accessor :person
    #     
    #     def initialize(person)
    #       @person = person
    #     end
    #   end
    #
    # The person attribute will be validated.  If person is invalid the errors will be added to the PersonPresenter errors collection.
    def include_validations_for(*args)
      children_to_validate.concat args
    end
    
    def validate(instance) #:nodoc:
      self.validations.each do |validation|
        instance.errors.add(validation.attribute, validation.message) unless validation.valid?(instance)
      end
    end
    
    def validate_children(instance) #:nodoc:
      self.children_to_validate.each do |child_name|
        child = instance.send child_name
        child.valid?
        child.errors.each do |attribute, message|
          instance.errors.add(attribute, message)
        end
      end
    end

    protected
    def validate_all(args, &block) #:nodoc:
      options = args.last.is_a?(Hash) ? args.pop : {}
      args.each do |attribute|
        yield attribute, options[:message], options
      end
    end
    
    def children_to_validate #:nodoc:
      @children_to_validate ||= []
    end
    
    def validations #:nodoc:
      @validations ||= []
    end
  end
  
  def self.included(klass) #:nodoc:
    klass.extend Validatable::ClassMethods
  end
  
  # call-seq: valid?
  #
  # Returns true if no errors were added otherwise false.
  def valid?
    errors.clear
    self.class.validate(self)
    self.class.validate_children(self)
    errors.empty?
  end
  
  # call-seq: errors
  #
  # Returns the Errors object that holds all information about attribute error messages.
  def errors
    @errors ||= Validatable::Errors.new
  end
end