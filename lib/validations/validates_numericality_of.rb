module Validatable 
  class ValidatesNumericalityOf < ValidationBase #:nodoc:

    def valid?(instance)
      not (instance.send(self.attribute).to_s =~ /^\d*\.{0,1}\d+$/).nil?
    end
    
    def message
      super || "must be a number"
    end
  end
end

