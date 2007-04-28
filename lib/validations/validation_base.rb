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
      
      def all_defaults
        return defaults.merge(self.superclass.all_defaults) if self.superclass.respond_to? :all_defaults
        defaults
      end
      
      def after_validate(&block)
        after_validations << block
      end
      
      def after_validations
        @after_validations ||= []
      end
      
      def all_after_validations
        return after_validations + self.superclass.all_after_validations if self.superclass.respond_to? :all_after_validations
        after_validations
      end
    end

    option :message, :if, :times, :level, :groups
    default :if => lambda { true }, :level => 1, :groups => []
    attr_accessor :attribute
    
    def initialize(attribute, options={})
      self.class.all_understandings.each do |understanding|
        options[understanding] = self.class.all_defaults[understanding] unless options.has_key? understanding
        self.instance_variable_set("@#{understanding}", options[understanding])
      end
      self.attribute = attribute
      self.groups = [self.groups] unless self.groups.is_a?(Array)
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