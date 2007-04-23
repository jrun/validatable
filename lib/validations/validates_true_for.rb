module Validatable
  class ValidatesTrueFor < ValidationBase #:nodoc:
    attr_accessor :logic
  
    def valid?(instance)
      instance.instance_eval(&logic) == true
    end
    
    def message
      super || "is invalid"
    end
  end
end