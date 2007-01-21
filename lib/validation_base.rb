module Validatable
  class ValidationBase
    attr_accessor :message
    def initialize(message)
      self.message = message
    end
  end
end