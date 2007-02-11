module Validatable
  class ValidationBase #:nodoc:
    attr_accessor :attribute, :message
    
    def initialize(attribute, options={})
      @attribute = attribute
      @message = options[:message]
      @conditional = options[:conditional] || Proc.new { true }
      @times = options[:times]
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