require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ErrorsTest < Test::Unit::TestCase
  expect "message" do
    errors = Validatable::Errors.new
    errors.add(:attribute, "message")
    errors.on(:attribute)
  end
end