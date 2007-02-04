module Validatable
  class ValidationBase #:nodoc:
    attr_accessor :attribute, :message
    
    def initialize(attribute, message)
      @attribute, @message = attribute, message
    end
  end
end