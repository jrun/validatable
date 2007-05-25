require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidationAssertionCollectorTest < Test::Unit::TestCase
  expect 1 do
    assertions = ValidationAssertionCollector.gather(Class.new) do
      presence_of :name
    end
    assertions.size
  end
  
  expect "save this message" do
    assertions = ValidationAssertionCollector.gather(Class.new) do
      presence_of(:name).message("ignore this message").message("save this message")
    end
    assertions.first.options[:message]
  end
  
  expect :class_being_validated do
    assertions = ValidationAssertionCollector.gather(:class_being_validated) do
      presence_of(:name)
    end
    assertions.first.klass
  end
  
  expect NoMethodError do
    assertions = ValidationAssertionCollector.gather(Class.new) do
      presence_of(:name).invalid_option
    end
  end
    
  expect NoMethodError do
    assertions = ValidationAssertionCollector.gather(Class.new) do
      true_for(:name)
    end
  end
  
  expect NoMethodError do
    assertions = ValidationAssertionCollector.gather(Class.new) do
      presence_of(:name).if lambda { true }
    end
  end
  
  expect Validatable::ValidatesPresenceOf do
    assertions = ValidationAssertionCollector.gather(Class.new) do
      presence_of(:name)
    end
    assertions.first.validation_type
  end
end