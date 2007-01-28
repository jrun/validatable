module Validatable
  class Errors
    extend Forwardable
    
    def_delegators :errors, :empty?, :clear
    
    def on(attribute)
      errors[attribute.to_sym]
    end
    
    def add(attribute, message)
      errors[attribute.to_sym] = message
    end

    def errors
      @errors ||= {}
    end
  end
end