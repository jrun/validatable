require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Validatable::AssertionsTest < Test::Unit::TestCase
  expect "Klass does not contain a ValidationType for Attribute" do
    klass = Class.new do
      include Validatable::Assertions
    end
    klass.new.create_message_for_assertion(stub(:klass=>"Klass", :validation_type=>"ValidationType", :attribute=>"Attribute", :options=>{}))
  end

  expect "Klass does not contain a ValidationType for Attribute" do
    klass = Class.new do
      include Validatable::Assertions
    end
    klass.new.create_message_for_assertion(stub(:klass=>"Klass", :validation_type=>"ValidationType", :attribute=>"Attribute", :options=>{}))
  end
  
  expect false do
    klass = Class.new do
      include Validatable::Assertions
    end
    assertion = stub(:validation_type=>stub(:=== => true), :attribute => "attribute", :options=>{:level => 1, :times => 2})
    validation = stub(:validation_type=>"validation_type", :attribute => "attribute", :level => 2, :times => 2)
    klass.new.validation_matching_proc(assertion).call(validation)
  end

  expect false do
    klass = Class.new do
      include Validatable::Assertions
    end
    assertion = stub(:validation_type=>stub(:=== => true), :attribute => "non matching attribute", :options=>{})
    validation = stub(:validation_type=>"validation_type", :attribute => nil)
    klass.new.validation_matching_proc(assertion).call(validation)
  end
  
  expect false do
    klass = Class.new do
      include Validatable::Assertions
    end
    assertion = stub(:validation_type=>"non matching validation_type", :options=>{})
    validation = stub(:validation_type=>"validation_type")
    klass.new.validation_matching_proc(assertion).call(validation)
  end

  expect true do
    klass = Class.new do
      include Validatable::Assertions
    end
    assertion = stub(:validation_type=>stub(:=== => true), :attribute => "attribute", :options=>{:level => 1, :times => 2})
    validation = stub(:validation_type=>"validation_type", :attribute => "attribute", :level => 1, :times => 2)
    klass.new.validation_matching_proc(assertion).call(validation)
  end
  
  expect true do
    Class.new do
      include Validatable::Assertions
    end
    
    Class.respond_to? :must_validate
  end
  
  expect "test_validates_presence_of_name" do
    test_class = Class.new(Test::Unit::TestCase) do
      include Validatable::Assertions
    end
    test_class.create_test_name(stub(:validation_type=>Validatable::ValidatesPresenceOf, :attribute=>:name))
  end
  
  expect true do
    test_class = Class.new(Test::Unit::TestCase) do
      include Validatable::Assertions
    end
    
    test_class.define_test_method :some_test do 
      true 
    end
    
    test_class.instance_methods.include? "some_test"
  end
  
  expect true do
    klass = Class.new do
      include Validatable
    end
    test_class = Class.new Test::Unit::TestCase do
      include Validatable::Assertions
      
      klass.must_validate do
        presence_of :anything
      end
      
    end
    
    test_class.any_instance.expects(:add_failure)
    test_class.new(:test_validates_presence_of_anything).test_validates_presence_of_anything
    true
  end
end