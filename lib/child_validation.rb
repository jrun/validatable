module Validatable
  class ChildValidation
    attr_accessor :attribute, :map
    
    def initialize(attribute, map)
      @attribute = attribute
      @map = map
    end
  end
end