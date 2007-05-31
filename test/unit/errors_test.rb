require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ErrorsTest < Test::Unit::TestCase
  expect "message" do
    errors = Validatable::Errors.new
    errors.add(:attribute, "message")
    errors.on(:attribute)
  end
  
  expect "Capitalized word" do
    errors = Validatable::Errors.new
    errors.humanize("capitalized_word")
  end
  
  expect "Capitalized word without" do
    errors = Validatable::Errors.new
    errors.humanize("capitalized_word_without_id")
  end
  
  expect ["A humanized message", "a base message"] do
    errors = Validatable::Errors.new
    errors.add(:base, "a base message")
    errors.add(:a_humanized, "message")
    errors.full_messages.sort
  end
  
  test "includes enumerable" do
    assert_equal true, Validatable::Errors.included_modules.include?(Enumerable)
  end
end