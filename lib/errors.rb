module Validatable
  class Errors
    extend Forwardable
    
    def_delegators :errors, :empty?, :clear, :each, :each_pair, :merge, :size, :length
    
    # call-seq: on(attribute)
    # 
    # Returns nil, if no errors are associated with the specified attribute.
    # Returns the error message, if one error is associated with the specified attribute.
    def on(attribute)
      errors[attribute.to_sym]
    end
    
    def add(attribute, message) #:nodoc:
      errors[attribute.to_sym] = message
    end
    
    def merge!(errors) #:nodoc:
      errors.each_pair{|k, v| add(k,v)}
      self
    end

    def errors #:nodoc:
      @errors ||= {}
    end
  end
end