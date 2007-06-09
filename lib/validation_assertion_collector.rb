class ValidationAssertionCollector #:nodoc:
  def self.gather(klass, &block)
    collector = self.new(klass)
    collector.instance_eval(&block)
    collector.assertions
  end
  
  def self.define_method_for_validation_method(validation_method, validatable_class)
    define_method validation_method.gsub(/^validates_/,'').to_sym do |attribute|
      assertions << ValidationAssertion.new(self.klass, validatable_class, attribute)
      define_methods_on_assertion_to_collect_options validatable_class, assertions.last
    end
  end

  Validatable::Macros.public_instance_methods.sort.grep(/^validates_/).each do |validation_method|
    next if validation_method == 'validates_true_for'
    validatable_class = Validatable.const_get(validation_method.split(/_/).collect { |word| word.capitalize}.join)
    define_method_for_validation_method(validation_method, validatable_class)
  end
  
  attr_accessor :klass
  
  def initialize(klass)
    self.klass = klass
  end
    
  def define_methods_on_assertion_to_collect_options(validatable_class, assertion)
    validatable_class.all_understandings.each do |option|
      next if option == :if
      class << assertion; self; end.instance_eval do
        define_method option do |value|
          self.options.merge!(option=>value)
          self
        end
      end
    end
    assertion
  end
  
  def assertions
    @assertions ||= []
  end
end