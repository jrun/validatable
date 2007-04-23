module Validatable
  class ValidatesConfirmationOf < ValidationBase #:nodoc:
    attr_accessor :case_sensitive
    
    def valid?(instance)
      result = Regexp.new(instance.send(self.attribute), !case_sensitive) =~ instance.send("#{self.attribute}_confirmation".to_sym)
      result.nil? ? false : true
    end
    
    def message
      super || "doesn't match confirmation"
    end
  end
end