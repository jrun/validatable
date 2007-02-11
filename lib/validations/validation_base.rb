module Validatable
  class ValidationBase #:nodoc:
    attr_accessor :attribute, :message
    
    def initialize(attribute, message=nil, conditional=nil, times=nil)
      @attribute, @message, @conditional, @times = attribute, message, conditional|| Proc.new { true }, times
    end
    
    def should_validate?(instance)
      instance.instance_eval(&@conditional)
    end
  end
end