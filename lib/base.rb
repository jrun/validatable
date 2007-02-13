module Validatable
  module ClassMethods
    # call-seq: validates_format_of(*args)
    # 
    # Validates whether the value of the specified attribute is of the correct form by matching it against the regular expression provided.
    # 
    #   class Person
    #     include Validatable    
    #     validates_format_of :first_name, :with => /[ A-Za-z]/
    #   end
    # 
    # A regular expression must be provided or else an exception will be raised.
    # 
    # Configuration options:
    # 
    #     * message - The message to add to the errors collection when the validation fails
    #     * times - The number of times the validation applies
    #     * level - The level at which the validation should occur
    #     * if - A block that when executed must return true of the validation will not occur
    #     * with - The regular expression used to validate the format
    def validates_format_of(*args)
      add_validations(args, ValidatesFormatOf) do |validation, options|
        validation.with = options[:with]
      end
    end
    
    # call-seq: validates_length_of(*args)
    # 
    # Validates that the specified attribute matches the length restrictions supplied.
    # 
    #   class Person
    #     include Validatable
    #     validates_length_of :first_name, :maximum=>30
    #     validates_length_of :last_name, :minimum=>30
    #   end
    # 
    # Configuration options:
    # 
    #     * message - The message to add to the errors collection when the validation fails
    #     * times - The number of times the validation applies
    #     * level - The level at which the validation should occur
    #     * if - A block that when executed must return true of the validation will not occur
    #     * minimum - The minimum size of the attribute
    #     * maximum - The maximum size of the attribute
    def validates_length_of(*args)
      add_validations(args, ValidatesLengthOf) do |validation, options|
        validation.minimum = options[:minimum]
        validation.maximum = options[:maximum]
      end
    end

    # call-seq: validates_acceptance_of(*args)
    #
    # Encapsulates the pattern of wanting to validate the acceptance of a terms of service check box (or similar agreement). Example:
    # 
    #   class Person
    #     include Validatable
    #     validates_acceptance_of :terms_of_service
    #     validates_acceptance_of :eula, :message => "must be abided"
    #   end
    #
    # Configuration options:
    # 
    #     * message - The message to add to the errors collection when the validation fails
    #     * times - The number of times the validation applies
    #     * level - The level at which the validation should occur
    #     * if - A block that when executed must return true of the validation will not occur
    def validates_acceptance_of(*args)
      add_validations(args, ValidatesAcceptanceOf)
    end

    # call-seq: validates_confirmation_of(*args)
    #
    # Encapsulates the pattern of wanting to validate a password or email address field with a confirmation. Example:
    # 
    #   Class:
    #     class PersonPresenter
    #       include Validatable
    #       validates_confirmation_of :user_name, :password
    #       validates_confirmation_of :email_address, :message => "should match confirmation"
    #     end
    # 
    #   View:
    #     <%= password_field "person", "password" %>
    #     <%= password_field "person", "password_confirmation" %>
    #
    # Configuration options:
    # 
    #     * message - The message to add to the errors collection when the validation fails
    #     * times - The number of times the validation applies
    #     * level - The level at which the validation should occur
    #     * if - A block that when executed must return true of the validation will not occur
    def validates_confirmation_of(*args)
      add_validations(args, ValidatesConfirmationOf)
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
    #
    # Configuration options:
    # 
    #     * message - The message to add to the errors collection when the validation fails
    #     * times - The number of times the validation applies
    #     * level - The level at which the validation should occur
    #     * if - A block that when executed must return true of the validation will not occur
    def validates_presence_of(*args)
      add_validations(args, ValidatesPresenceOf)
    end
    
    # call-seq: include_validations_for(*args)
    # 
    # Validates the specified attributes.
    #   class Person
    #     include Validatable
    #     validates_presence_of :name
    #     attr_accessor :name
    #   end
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
    #   presenter = PersonPresenter.new(Person.new)
    #   presenter.valid? #=> false
    #   presenter.errors.on(:name) #=> "can't be blank"
    #
    # The person attribute will be validated.  If person is invalid the errors will be added to the PersonPresenter errors collection.
    def include_validations_for(*args)
      children_to_validate.concat args
    end
    
    def validate(instance) #:nodoc:
      levels = self.validations.collect { |validation| validation.level }.uniq
      levels.sort.each do |level|
        self.validations.select { |validation| validation.level == level }.each do |validation|
          if validation.should_validate?(instance)
            instance.errors.add(validation.attribute, validation.message) unless validation.valid?(instance)
          end
        end
        return unless instance.errors.empty?
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

    def validations #:nodoc:
      @validations ||= []
    end

    protected
    def add_validations(args, klass) #:nodoc:
      options = args.last.is_a?(Hash) ? args.pop : {}
      args.each do |attribute|
        new_validation = klass.new(attribute, options)
        yield new_validation, options if block_given?
        self.validations << new_validation
      end
    end
    
    def children_to_validate #:nodoc:
      @children_to_validate ||= []
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
    self.class.validate_children(self)
    self.validate
    errors.empty?
  end
  
  # call-seq: errors
  #
  # Returns the Errors object that holds all information about attribute error messages.
  def errors
    @errors ||= Validatable::Errors.new
  end
  
  protected
  def validate #:nodoc:
    validation_levels.sort.each do |level|
      validations_for_level(level).each do |validation|
        if validation.should_validate?(self)
          self.errors.add(validation.attribute, validation.message) unless validation.valid?(self)
        end
      end
      return unless self.errors.empty?
    end
  end
  
  def validation_levels #:nodoc:
    self.validations.collect { |validation| validation.level }.uniq
  end
  
  def validations_for_level(level) #:nodoc:
    self.validations.select { |validation| validation.level == level }
  end
  
  def validations #:nodoc:
    @validations ||= self.class.validations.collect { |validation| validation.dup }
  end
end