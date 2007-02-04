module Validatable
  class ValidatesLengthOf < ValidationBase #:nodoc:
    attr_accessor :attribute, :minimum, :maximum
    def initialize(attribute, minimum, maximum, message, conditional)
      self.minimum = minimum
      self.maximum = maximum
      super attribute, message, conditional
    end
    
    def valid?(instance)
      valid = true
      value = instance.send(self.attribute) || ""
      valid &&= value.length <= maximum unless maximum.nil? 
      valid &&= value.length >= minimum unless minimum.nil?
      valid
    end
  end
end
