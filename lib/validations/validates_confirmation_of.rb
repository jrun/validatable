module Validatable
  class ValidatesConfirmationOf < ValidationBase #:nodoc:
    def valid?(instance)
      instance.send(self.attribute) == instance.send("#{self.attribute}_confirmation".to_sym)
    end
  end
end