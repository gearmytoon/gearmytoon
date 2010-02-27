require File.dirname(__FILE__) + '/../test_helper'

class WowClassTest < ActiveSupport::TestCase
  should "serialize stat_multipliers" do
    expected_stat_multipliers = {:a => 1}
    wow_class = Factory(:wow_class, :stat_multipliers => expected_stat_multipliers)
    assert_equal expected_stat_multipliers, wow_class.reload.stat_multipliers
  end
  context "associations" do
    should_belong_to :primary_armor_type
  end
  context "equippable_items" do
    should "find upgrades of the same armor type" do
      rogue = WowClass.create!(WowClass::WowClassConstants::Rogue)
      plate_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :inventory_type => 2, :armor_type => ArmorType.Plate)
      leather_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :inventory_type => 2, :armor_type => ArmorType.Leather)
      assert_equal 1, rogue.equippable_items.size
      assert_equal leather_upgrade, rogue.equippable_items.first
    end
  end

end
