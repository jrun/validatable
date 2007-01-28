require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class ErrorsTest < Test::Unit::TestCase
  test "when an error is added, then it can be returned from on" do
    errors = Validatable::Errors.new
    errors.add(:attribute, "message")
    assert_equal "message", errors.on(:attribute)
  end
end