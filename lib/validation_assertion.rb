class ValidationAssertion
  attr_accessor :klass, :validation_type, :options, :attribute
  
  def initialize(klass, validation_type, attribute)
    self.klass, self.validation_type, self.attribute, self.options = klass, validation_type, attribute, {}
  end
end