module Validatable
  class ValidatesFormatOf < ValidationBase #:nodoc:
    attr_accessor :regex
    def initialize(attribute, regex, message, conditional)
      self.regex = regex
      super attribute, message, conditional
    end
  
    def valid?(instance)
      instance.send(self.attribute) =~ self.regex && true
    end
  end
end