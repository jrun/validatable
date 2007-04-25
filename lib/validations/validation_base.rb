module Validatable
  class ValidationBase #:nodoc:
    attr_accessor :attribute, :message, :times
    attr_reader :level, :groups
    
    def initialize(attribute, options={})
      @attribute = attribute
      @message = options[:message]
      @conditional = options[:if] || Proc.new { true }
      @times = options[:times]
      @level = options[:level] || 1
      @groups = options[:groups].is_a?(Array) ? options[:groups] : [options[:groups]]
    end
    
    def should_validate?(instance)
      instance.instance_eval(&@conditional) && validate_this_time?
    end
    
    def validate_this_time?
      return true if @times.nil?
      self.times -= 1
      self.times >= 0
    end
    
    def run_after_validate(result, instance, attribute)
      self.class.all_after_validations.each do |block|
        block.call result, instance, attribute
      end
    end
    
    class << self
      def after_validate(&block)
        after_validations << block
      end
      
      def after_validations
        @after_validations ||= []
      end
      
      def all_after_validations
        return after_validations + self.superclass.after_validations if self.superclass.respond_to? :after_validations
        after_validations
      end
    end
  end
end