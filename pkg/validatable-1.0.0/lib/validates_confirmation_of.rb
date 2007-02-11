module Validatable
  class ValidatesConfirmationOf < ValidationBase #:nodoc:
    def valid?(instance)
      instance.send(self.attribute) == instance.send("#{self.attribute}_confirmation".to_sym)
    end
    
    def message
      super || "doesn't match confirmation"
    end
  end
end