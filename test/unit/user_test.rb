require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  should "have many characters through user characters" do
    user = Factory(:user)
    user_character = Factory(:user_character, :subscriber => user)
    assert user.reload.characters.include?(user_character.character)
  end
  
  should "have a most recent payment" do
    purchaser = Factory(:user)
    Factory(:paid_payment, :purchaser => purchaser).update_attribute(:paid_at, 1.day.ago)
    Factory(:paid_payment, :purchaser => purchaser).update_attribute(:paid_at, 10.day.ago)
    latest_payment = Factory(:paid_payment, :purchaser => purchaser)
    assert_equal latest_payment, purchaser.most_recent_paid_payment
  end

  context "active_subscriber?" do
    should "know if a account has lapsed payment" do
      purchaser = Factory(:user)
      Factory(:paid_payment, :purchaser => purchaser).update_attribute(:paid_at, 37.day.ago)
      assert_false purchaser.active_subscriber?
    end

    should "know if a account is activily paying" do
      purchaser = Factory(:user)
      Factory(:paid_payment, :purchaser => purchaser)
      assert purchaser.active_subscriber?
    end

    should "know if a account is not activily paying" do
      purchaser = Factory(:user)
      Factory(:considering_payment, :purchaser => purchaser)
      assert_false purchaser.active_subscriber?
    end
  end
end
