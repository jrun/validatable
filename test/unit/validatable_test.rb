require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Unit
  class ValidatableTest < Test::Unit::TestCase
    expect false do
      validation = stub(:valid? => false, :should_validate? => true, :attribute => "attribute", :message => "message", :level => 1)
      klass = Class.new do
        include Validatable
        validations << validation
      end
      klass.new.valid?
    end
  
    expect [:anything, :else] do
      klass = Class.new do
        include Validatable
        include_validations_for :anything, :else
      end
      klass.send(:children_to_validate)
    end
  
    test "when validate is executed, then messages are added for each validation that fails" do
      klass = Class.new do
        include Validatable
      end
      klass.send(:validations) << stub(:valid? => false, :should_validate? => true, :attribute => 'attribute', :message => 'message', :level => 1)
      klass.send(:validations) << stub(:valid? => false, :should_validate? => true, :attribute => 'attribute2', :message => 'message2', :level => 1)
      instance=mock
      instance.expects(:errors).returns(errors=mock).times 3
      errors.expects(:add).with('attribute', 'message')
      errors.expects(:add).with('attribute2', 'message2')
      errors.expects(:empty?).returns true
      klass.validate(instance)
    end

    expect true do
      klass = Class.new do
        include Validatable
      end
      instance = klass.new
      instance.errors.add(:attribute, "message")
      instance.valid?
      instance.errors.empty?
    end
  
  end
end