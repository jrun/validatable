module Validatable
  class ValidatesConfirmationOf < ValidationBase #:nodoc:
    attr_accessor :case_sensitive
    
    def valid?(instance)
      return instance.send(self.attribute) == instance.send("#{self.attribute}_confirmation".to_sym) if case_sensitive
      instance.send(self.attribute).to_s.casecmp(instance.send("#{self.attribute}_confirmation".to_sym).to_s) == 0
    end
    
    def message
      super || "doesn't match confirmation"
    end
  end
end