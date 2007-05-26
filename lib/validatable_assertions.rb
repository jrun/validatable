module ValidatableAssertions

  def create_message_for_assertion(assertion)
    message = "#{assertion.klass} does not contain a #{assertion.validation_type} for #{assertion.attribute}"
    message += " with options #{assertion.options.inspect}" unless assertion.options == {}
    message
  end

  def create_backtrace
    backtrace = caller
    backtrace.shift
    backtrace.shift
    backtrace
  end

  def validation_matching_proc(assertion)
    lambda do |validation|
      result = assertion.validation_type === validation
      result &&= assertion.attribute == validation.attribute
      assertion.options.each_pair do |key, value|
        validation_value = validation.send key if validation.respond_to? key
        result = false if validation_value.nil?
        result &&= validation_value == value
      end
      result
    end
  end

  def self.included(klass)
    Test::Unit::TestCase.class_eval do
      def self.create_test_name(assertion)
        "test#{assertion.validation_type.to_s.gsub(/Validatable::/,'').gsub(/([A-Z])/, '_\1').downcase}_#{assertion.attribute}"
      end

      def self.define_test_method name, &block
        class_eval do
          define_method name, &block
        end
      end
    end

    Class.class_eval do
      def must_validate(&block)
        test_class = eval "self", block.binding
        ValidationAssertionCollector.gather(self, &block).each do |assertion|
          test_class.define_test_method test_class.create_test_name(assertion) do
            validation = assertion.klass.validations.find &validation_matching_proc(assertion)
            add_failure create_message_for_assertion(assertion), create_backtrace if validation.nil?
          end
        end
      end
    end
  end
end