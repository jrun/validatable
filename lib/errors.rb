module Validatable
  class Errors
    extend Forwardable
    
    def_delegators :@errors, :empty?
    
    def on(attribute)
      @errors[attribute.to_sym]
    end
    
    def add(attribute, message)
      @errors[attribute.to_sym] = message
    end

    def initialize
      @errors = {}
    end
  end
end