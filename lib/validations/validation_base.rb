module Validatable
  class ValidationBase #:nodoc:
    attr_accessor :attribute, :message
    
    def initialize(attribute, message=nil, conditional=nil, times=nil)
      @attribute, @message, @conditional, @times = attribute, message, conditional|| Proc.new { true }, times
    end
    
    def should_validate?(instance)
      instance.instance_eval(&@conditional) && validate_this_time?
    end
    
    def validate_this_time?
      return true if @times.nil?
      @times -= 1
      @times >= 0
    end
  end
end