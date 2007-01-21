module Validatable
  class ValidatesPresenceOf < ValidationBase
    attr_accessor :attribute
    def initialize(attribute, message)
      self.attribute = attribute
      super message
    end

    def valid?(instance)
      (!instance.send(self.attribute).nil? && instance.send(self.attribute).strip.length != 0)
    end
  end
end