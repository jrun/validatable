module Validatable
  class ValidatesAcceptanceOf < ValidationBase #:nodoc:
    def valid?(instance)
      instance.send(self.attribute) == "true"
    end
  end
end