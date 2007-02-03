require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class ValidatableTest < Test::Unit::TestCase
  test "given a validation that returns false when object is validated then valid returns false" do
    validation = stub(:valid? => false, :attribute => "attribute", :message => "message")
    klass = Class.new do
      include Validatable
      validations << validation
    end
    assert_equal false, klass.new.valid?
  end
  
  test "when validations are included for a child, then the list is maintained as an array of args" do
    klass = Class.new do
      include Validatable
      include_validations_for :anything, :else
    end
    assert_equal [:anything, :else], klass.children_to_validate
  end
  
  test "when validate is executed, then messages are added for each validation that fails" do
    klass = Class.new do
      include Validatable
    end
    klass.validations << stub(:valid? => false, :attribute => 'attribute', :message => 'message')
    klass.validations << stub(:valid? => false, :attribute => 'attribute2', :message => 'message2')
    instance=mock
    instance.expects(:errors).returns(errors=mock).times 3
    errors.expects(:add).with('attribute', 'message')
    errors.expects(:add).with('attribute2', 'message2')
    errors.expects(:empty?)
    klass.validate(instance)
  end

  test "when valid is called, then the errors collection is cleared and reinitialized" do
    klass = Class.new do
      include Validatable
    end
    instance = klass.new
    instance.errors.add(:attribute, "message")
    instance.valid?
    assert_equal true, instance.errors.empty?
  end
  
end