require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidatableAssertionsTest < Test::Unit::TestCase
  expect "Klass does not contain a ValidationType for Attribute" do
    klass = Class.new do
      include ValidatableAssertions
    end
    klass.new.create_message_for_assertion(stub(:klass=>"Klass", :validation_type=>"ValidationType", :attribute=>"Attribute", :options=>{}))
  end

  expect "Klass does not contain a ValidationType for Attribute" do
    klass = Class.new do
      include ValidatableAssertions
    end
    klass.new.create_message_for_assertion(stub(:klass=>"Klass", :validation_type=>"ValidationType", :attribute=>"Attribute", :options=>{}))
  end
  
  expect false do
    klass = Class.new do
      include ValidatableAssertions
    end
    assertion = stub(:validation_type=>stub(:=== => true), :attribute => "attribute", :options=>{:level => 1, :times => 2})
    validation = stub(:validation_type=>"validation_type", :attribute => "attribute", :level => 2, :times => 2)
    klass.new.validation_matching_proc(assertion).call(validation)
  end

  expect false do
    klass = Class.new do
      include ValidatableAssertions
    end
    assertion = stub(:validation_type=>stub(:=== => true), :attribute => "non matching attribute", :options=>{})
    validation = stub(:validation_type=>"validation_type", :attribute => nil)
    klass.new.validation_matching_proc(assertion).call(validation)
  end
  
  expect false do
    klass = Class.new do
      include ValidatableAssertions
    end
    assertion = stub(:validation_type=>"non matching validation_type", :options=>{})
    validation = stub(:validation_type=>"validation_type")
    klass.new.validation_matching_proc(assertion).call(validation)
  end

  expect true do
    klass = Class.new do
      include ValidatableAssertions
    end
    assertion = stub(:validation_type=>stub(:=== => true), :attribute => "attribute", :options=>{:level => 1, :times => 2})
    validation = stub(:validation_type=>"validation_type", :attribute => "attribute", :level => 1, :times => 2)
    klass.new.validation_matching_proc(assertion).call(validation)
  end
  
end


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
    Class.class_eval do
      def must_validate(&block)
        test_class = eval "self", block.binding
        ValidationAssertionCollector.gather(self, &block).each do |assertion|
          test_class.class_eval do
            name = "test#{assertion.validation_type.to_s.gsub(/Validatable::/,'').gsub(/([A-Z])/, '_\1').downcase}_#{assertion.attribute}"
            define_method name do
              validation = assertion.klass.validations.find &validation_matching_proc(assertion)
              add_failure create_message_for_assertion(assertion), create_backtrace if validation.nil?
            end
          end
        end
      end
    end
  end
end

# class Foo
#   include Validatable
#   validates_presence_of :name
#   validates_format_of :name, :with => /foo/
#   validates_format_of :address, :with => /x/
#   validates_length_of :ssn, :maximum => 1, :minimum => 2, :is => 10
# end
# 
# module Functional
#   class ValidatableAssertionsTest < Test::Unit::TestCase
#     include ValidatableAssertions
#     
#     Foo.must_validate do
#       presence_of :name
#       presence_of :address
#       format_of(:name).with(/foo/)
#       format_of(:address).with(/bar/)
#       length_of(:ssn).maximum(1).minimum(2).is(10)
#     end
#   end
# end
# 
