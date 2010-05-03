require File.dirname(__FILE__) + '/../test_helper'

class UserCharacterTest < ActiveSupport::TestCase
  should "belong_to subscriber" do
    user = Factory(:user)
    user_character = Factory(:user_character, :subscriber => user)
    assert_equal user, user_character.reload.subscriber
  end
end
