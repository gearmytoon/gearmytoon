require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  should "have many characters through user characters" do
    user = Factory(:user)
    user_character = Factory(:user_character, :subscriber => user)
    assert user.reload.characters.include?(user_character.character)
  end
end
