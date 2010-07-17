require File.dirname(__FILE__) + '/../../test_helper'

class ItemInfoHelperTest < ActionView::TestCase
  context "equipped_stat_string" do
    should "return correct result for crit strike" do
      assert_equal "Improves critical strike rating by 108", equipped_stat_string(:crit, 108)
    end
    should "return correct result for hit" do
      assert_equal "Improves hit rating by 108", equipped_stat_string(:hit, 108)
    end
    should "return correct result for haste" do
      assert_equal "Improves haste rating by 108", equipped_stat_string(:haste, 108)
    end
    should "return correct result for attack power" do
      assert_equal "Increases your attack power by 105", equipped_stat_string(:attack_power, 105)
    end
    should "return correct result for :armor_penetration" do
      assert_equal "Increases your armor penetration by 102", equipped_stat_string(:armor_penetration, 102)
    end
    should "return correct result for spell power" do
      assert_equal "Increases your spell power by 105", equipped_stat_string(:spell_power, 105)
    end
    should "return correct result for mp5 " do
      assert_equal "Restores 105 mana per 5 secs", equipped_stat_string(:mana_regen, 105)
    end
    should "return correct result for defense" do
      assert_equal "Increases defense rating by 105", equipped_stat_string(:defense, 105)
    end
    should "return correct result for dodge" do
      assert_equal "Increases defense rating by 105", equipped_stat_string(:defense, 105)
    end
    should "return correct result for parry" do
      assert_equal "Increases defense rating by 105", equipped_stat_string(:defense, 105)
    end
    should "return correct result for block value" do
      assert_equal "Increases the block value of your shield by 105", equipped_stat_string(:block_value, 105)
    end
  end
end
