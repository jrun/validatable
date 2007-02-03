module Validatable
  class Errors
    extend Forwardable
    
    def_delegators :errors, :empty?, :clear, :each
    
    def on(attribute)
      errors[attribute.to_sym]
    end
    
    def add(attribute, message)
      errors[attribute.to_sym] = message
    end

    def errors #:nodoc:
      @errors ||= {}
    end
  end
end