require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Functional
  class ValidatesConfirmationOfTest < Test::Unit::TestCase
    test "given non matching attributes, when validated, then error is in the objects error collection" do
      klass = Class.new do
        include Validatable
        attr_accessor :name, :name_confirmation
        validates_confirmation_of :name
      end
      instance = klass.new
      instance.name = "foo"
      instance.name_confirmation = "bar"
      instance.valid?
      assert_equal "doesn't match confirmation", instance.errors.on(:name)
    end
  end
end