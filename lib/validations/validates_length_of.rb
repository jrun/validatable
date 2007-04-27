module Validatable
  class ValidatesLengthOf < ValidationBase #:nodoc:
    attr_accessor :minimum, :maximum, :is
    understands :minimum, :maximum, :is
    
    def message
      super || "is invalid"
    end
    
    def valid?(instance)
      valid = true
      value = instance.send(self.attribute) || ""
      valid &&= value.length <= maximum unless maximum.nil? 
      valid &&= value.length >= minimum unless minimum.nil?
      valid &&= value.length == is unless is.nil?
      valid
    end
  end
end
