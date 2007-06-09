module Validatable
  module Assertions

    def create_message_for_assertion(assertion) #:nodoc:
      message = "#{assertion.klass} does not contain a #{assertion.validation_type} for #{assertion.attribute}"
      message += " with options #{assertion.options.inspect}" unless assertion.options == {}
      message
    end

    def create_backtrace #:nodoc:
      backtrace = caller
      backtrace.shift
      backtrace.shift
      backtrace
    end

    def validation_matching_proc(assertion) #:nodoc:
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

    def self.included(klass) #:nodoc:
      Test::Unit::TestCase.class_eval do
        def self.create_test_name(assertion) #:nodoc:
          "test#{assertion.validation_type.to_s.gsub(/Validatable::/,'').gsub(/([A-Z])/, '_\1').downcase}_#{assertion.attribute}"
        end

        def self.define_test_method name, &block #:nodoc:
          class_eval do
            define_method name, &block
          end
        end
      end

      Class.class_eval do
        # call-seq: must_validate
        #
        #   class FooTest < Test::Unit::TestCase
        #     include Validatable::Assertions
        # 
        #     Foo.must_validate do
        #       presence_of :name
        #       format_of(:name).with(/^[A-Z]/)
        #       numericality_of(:age).only_integer(true)
        #     end
        #   end
        # 
        # The above code creates a test for each line in the block given to must_validate. 
        # If the Foo class does not contain a presence of validation for name, 
        # an error with the text "Foo does not contain a Validatable::ValidatesPresenceOf for name" will be raised.
        # 
        # Clearly this solution has limitations. Any validates_true_for validation cannot be tested using 
        # this DSL style of testing. Furthermore, any validation that uses an :if argument cannot use this DSL, 
        # since those validations require an instance to eval the :if argument against. However, for validations 
        # that are not validates_true_for and do not rely on an :if argument, the ValidatableAssertions can 
        # replace various existing success and failure validation tests.
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
end