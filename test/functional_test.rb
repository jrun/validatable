require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class FunctionalTest < Test::Unit::TestCase
  test "given no name, when validated, then valid is false" do
    klass = Class.new do
      include Validatable
      attr_accessor :name
      validates_presence_of :name
    end
    assert_equal false, klass.new.valid?
  end
  
  test "given no name, when validated, then error is in the objects error collection" do
    klass = Class.new do
      include Validatable
      attr_accessor :name
      validates_presence_of :name
    end
    instance = klass.new
    instance.valid?
    assert_equal "can't be empty", instance.errors.on(:name)
  end

  test "given invalid name format, when validated, then valid is false" do
    klass = Class.new do
      include Validatable
      attr_accessor :name
      validates_format_of :name, :with => /.+/
    end
    assert_equal false, klass.new.valid?
  end

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