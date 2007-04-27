module Validatable
  class ValidatesFormatOf < ValidationBase #:nodoc:
    attr_accessor :with
    understands :with
  
    def valid?(instance)
      not (instance.send(self.attribute).to_s =~ self.with).nil?
    end
    
    def message
      super || "is invalid"
    end
  end
end