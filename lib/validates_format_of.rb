module Validatable
  class ValidatesFormatOf < ValidationBase #:nodoc:
    attr_accessor :regex
    def initialize(attribute, regex, message)
      self.regex = regex
      super attribute, message
    end
  
    def valid?(instance)
      instance.send(self.attribute) =~ self.regex && true
    end
  end
end