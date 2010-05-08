require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  should "have many characters through user characters" do
    user = Factory(:user)
    user_character = Factory(:user_character, :subscriber => user)
    assert user.reload.characters.include?(user_character.character)
  end
  
  should "have a most recent payment" do
    purchaser = Factory(:user)
    Factory(:paid_payment, :purchaser => purchaser, :paid_at => 1.day.ago)
    Factory(:paid_payment, :purchaser => purchaser, :paid_at => 10.minutes.ago)
    latest_payment = Factory(:paid_payment, :purchaser => purchaser, :paid_at => Time.now)
    assert_equal latest_payment, purchaser.most_recent_payment
  end

  context "active_subscriber?" do
    should "know if a account has lapsed payment" do
      purchaser = Factory(:user)
      Factory(:paid_payment, :purchaser => purchaser, :paid_at => 37.days.ago)
      assert_false purchaser.active_subscriber?
    end

    should "know if a account is activily paying" do
      purchaser = Factory(:user)
      Factory(:paid_payment, :purchaser => purchaser, :paid_at => Time.now)
      assert purchaser.active_subscriber?
    end
  end
end
