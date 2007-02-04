require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Functional
  class ValidatesFormatOfTest < Test::Unit::TestCase
    test "given invalid name format, when validated, then error is in the objects error collection" do
      klass = Class.new do
        include Validatable
        attr_accessor :name
        validates_format_of :name, :with => /.+/
      end
      instance = klass.new
      instance.valid?
      assert_equal "is invalid", instance.errors.on(:name)
    end
  end
end