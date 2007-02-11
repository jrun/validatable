module Validatable
  class ValidationBase #:nodoc:
    attr_accessor :attribute, :message
    
    def initialize(attribute, message, conditional)
      @attribute, @message, @conditional = attribute, message, conditional|| Proc.new { true }
    end
    
    def if?(instance)
      instance.instance_eval(&@conditional)
    end
    
    def invalid?
      not valid?
    end
  end
end