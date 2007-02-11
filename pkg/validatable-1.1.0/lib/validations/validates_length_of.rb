module Validatable
  class ValidatesLengthOf < ValidationBase #:nodoc:
    attr_accessor :minimum, :maximum
    
    def message
      super || "is invalid"
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
