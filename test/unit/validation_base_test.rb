require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ValidationBaseTest < Test::Unit::TestCase
  expect true do
    validation = Validatable::ValidationBase.new(nil, nil, nil)
    validation.if? Object.new
  end
end