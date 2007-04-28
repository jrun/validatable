module Validatable 
  class ValidatesNumericalityOf < ValidationBase #:nodoc:
    attr_accessor :only_integer
    understands   :only_integer
    
    def valid?(instance)
      value = instance.send(self.attribute).to_s
      regex = self.only_integer ? /\A[+-]?\d+\Z/ : /^\d*\.{0,1}\d+$/
      not (value =~ regex).nil?
    end
    
    def message
      super || "must be a number"
    end
  end
end

