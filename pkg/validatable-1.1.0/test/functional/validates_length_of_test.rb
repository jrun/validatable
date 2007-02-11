require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Functional
  class ValidatesLengthOfTest < Test::Unit::TestCase
    test "given short value, when validated, then error is in the objects error collection" do
      klass = Class.new do
        include Validatable
        attr_accessor :name
        validates_length_of :name, :minimum => 2
      end
      instance = klass.new
      instance.valid?
      assert_equal "is invalid", instance.errors.on(:name)
    end
  end
end