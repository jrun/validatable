# require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
# 
# module ValidatableAssertions
#   
#   def create_message_for_assertion(assertion)
#     message = "#{assertion.klass} does not contain a #{assertion.validation_type} for #{assertion.attribute}"
#     message += " with options #{assertion.options.inspect}" if assertion.options != {}
#   end
#   
#   def create_backtrace
#     backtrace = caller
#     backtrace.shift
#     backtrace.shift
#     backtrace
#   end
#   
#   def validation_matching_proc(assertion)
#     lambda do |validation|
#       result = assertion.validation_type === validation
#       result &&= assertion.attribute == validation.attribute
#       assertion.options.each_pair do |key, value|
#         validation_value = validation.send key if validation.respond_to? key
#         result = false if validation_value.nil?
#         result &&= validation_value == value
#       end
#       result
#     end
#   end
#   
#   def self.included(klass)
#     Class.class_eval do
#       def must_validate(&block)
#         test_class = eval "self", block.binding
#         ValidationAssertionCollector.gather(self, &block).each do |assertion|
#           test_class.class_eval do
#             name = "test#{assertion.validation_type.to_s.gsub(/Validatable::/,'').gsub(/([A-Z])/, '_\1').downcase}_#{assertion.attribute}"
#             define_method name do
#               validation = assertion.klass.validations.find &validation_matching_proc(assertion)
#               add_failure create_message_for_assertion(assertion), create_backtrace if validation.nil?
#             end
#           end
#         end
#       end
#     end
#   end
# end
# 
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
