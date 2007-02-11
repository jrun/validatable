module Validatable
  class ValidatesFormatOf < ValidationBase #:nodoc:
    attr_accessor :with
  
    def valid?(instance)
      instance.send(self.attribute) =~ self.with && true
    end
    
    def message
      super || "is invalid"
    end
  end
end