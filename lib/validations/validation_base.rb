module Validatable
  class ValidationBase #:nodoc:
    class << self
      include Understandable
      
      def option(*args)
        attr_accessor *args
        understands *args
      end
      
      def default(hash)
        defaults.merge! hash
      end
      
      def defaults
        @defaults ||= {}
      end
      
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

    option :message, :if, :times, :level, :groups
    attr_accessor :attribute
    
    def initialize(attribute, options={})
      self.attribute = attribute
      self.message = options[:message]
      self.if = options[:if] || Proc.new { true }
      self.times = options[:times]
      self.level = options[:level] || 1
      self.groups = case options[:groups]
        when nil then []
        when Array then options[:groups]
        else [options[:groups]]
      end
    end
    
    def should_validate?(instance)
      instance.instance_eval(&self.if) && validate_this_time?
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
  end
end