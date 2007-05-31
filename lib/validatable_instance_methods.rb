module Validatable
  def self.included(klass) #:nodoc:
    klass.extend Validatable::ClassMethods
  end
  
  # call-seq: valid?
  #
  # Returns true if no errors were added otherwise false.
  def valid?
    valid_for_group?
  end
  
  # call-seq: errors
  #
  # Returns the Errors object that holds all information about attribute error messages.
  def errors
    @errors ||= Validatable::Errors.new
  end
  
  protected
  def valid_for_group?(*groups) #:nodoc:
    errors.clear
    self.class.validate_children(self, groups)
    self.validate(groups)
    errors.empty?
  end

  def validate(groups) #:nodoc:
    validation_levels.each do |level|
      validations_for_level_and_groups(level, groups).each do |validation|
        run_validation(validation) if validation.should_validate?(self)
      end
      return unless self.errors.empty?
    end
  end

  def run_validation(validation) #:nodoc:
    validation_result = validation.valid?(self)
    add_error(validation.attribute, validation.message(self)) unless validation_result
    validation.run_after_validate(validation_result, self, validation.attribute)
  end
  
  def add_error(attribute, message) #:nodoc:
    self.class.add_error(self, attribute, message)
  end
  
  def validations_for_level_and_groups(level, groups) #:nodoc:
    validations_for_level = self.validations.select { |validation| validation.level == level }
    return validations_for_level if groups.empty?
    validations_for_level.select { |validation| (groups & validation.groups).any? }
  end
  
  def validation_levels #:nodoc:
    self.validations.inject([1]) { |accum,validation| accum << validation.level }.uniq.sort
  end
  
  def validations #:nodoc:
    @validations ||= self.class.validations.collect { |validation| validation.dup }
  end
end