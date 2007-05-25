require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Unit
  class ValidatableTest < Test::Unit::TestCase
    expect false do
      validation = stub(:valid? => false, :should_validate? => true, 
                        :attribute => "attribute", :message => "message", :level => 1, :run_after_validate => nil)
      klass = Class.new do
        include Validatable
        validations << validation
      end
      klass.new.valid?
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