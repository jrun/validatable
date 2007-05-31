require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidationBaseTest < Test::Unit::TestCase
  expect true do
    validation = Validatable::ValidationBase.new :base
    validation.should_validate? Object.new
  end
  
  expect true do
    validation = Validatable::ValidationBase.new :base, :times => 1
    validation.validate_this_time?
  end
  
  expect true do
    validation = Validatable::ValidationBase.new :base
    validation.validate_this_time?
  end
  
  expect true do
    validation = Validatable::ValidationBase.new :base, :times => 2
    validation.validate_this_time?
    validation.validate_this_time?
  end

  expect false do
    validation = Validatable::ValidationBase.new :base, :times => 1
    validation.validate_this_time?
    validation.validate_this_time?
  end
  
  expect 1 do
    validation = Validatable::ValidationBase.new :base
    validation.level
  end
  
  expect "some message 100" do
    validation = Validatable::ValidationBase.new :base, :message => lambda { "some message #{a_method}" }
    validation.message(stub(:a_method=>'100'))
  end
  
  test "invalid option causes raise" do
    assert_raises ArgumentError do
      Validatable::ValidationBase.new(:base).must_understand(:foo => 1, :bar => 2)
    end
  end
  
  expect true do
    Validatable::ValidationBase.new(:base).must_understand(:message => nil, :if => nil, :times => nil, :level => nil, :groups => nil)
  end

end