require File.dirname(__FILE__) + '/../test_helper'

class WowClassTest < ActiveSupport::TestCase
  context "associations" do
    should_belong_to :primary_armor_type
    should "get stat_multipliers based on class_name" do
      wow_class = WowClass.create_class!("Rogue")
      assert_equal WowClass::WowClassConstants::Rogue.stat_multipliers("Combat"), wow_class.reload.stat_multipliers("Combat")
    end
  end

  context "stat_multipliers" do
    should "be based on a character spec" do
      wow_class = WowClass.create_class!("Hunter")
      assert_not_equal wow_class.stat_multipliers("Survival"), wow_class.stat_multipliers("Marksmanship")
      assert_not_equal wow_class.stat_multipliers("Survival"), wow_class.stat_multipliers("Beast Mastery")
      assert_not_equal wow_class.stat_multipliers("Marksmanship"), wow_class.stat_multipliers("Beast Mastery")
    end
    should "default to marksmanship for hunters who do not have a primary spec" do
      wow_class = WowClass.create_class!("Hunter")
      assert_equal wow_class.stat_multipliers("NONE"), wow_class.stat_multipliers("Marksmanship")
    end
  end

  context "equippable_items" do
    should "find upgrades of the same armor type" do
      rogue = WowClass.create_class!("Rogue")
      plate_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :inventory_type => 2, :armor_type => ArmorType.Plate)
      leather_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :inventory_type => 2, :armor_type => ArmorType.Leather)
      assert_equal 1, rogue.equippable_items.size
      assert_equal leather_upgrade, rogue.equippable_items.first
    end
  end

end
