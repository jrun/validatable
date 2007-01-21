module Validatable
  class ValidatesFormatOf < ValidationBase
    attr_accessor :attribute, :regex, :message
    def initialize(attribute, regex, message)
      self.attribute = attribute
      self.regex = regex
      super message
    end
  
    def valid?(instance)
      instance.send(self.attribute) =~ self.regex
    end
  end
end