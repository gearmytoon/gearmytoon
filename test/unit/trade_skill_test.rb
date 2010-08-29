require File.dirname(__FILE__) + '/../test_helper'

class TradeSkillTest < ActiveSupport::TestCase
  context "name" do
    should "remove trade_ and camelize wowarmory_name" do
      assert_equal "Engineering", Factory.build(:trade_skill, :wowarmory_name => "trade_engineering").name
    end
  end
end
