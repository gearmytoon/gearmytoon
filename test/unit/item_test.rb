require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase
  context "icon" do
    should "return a 43x43 image URL" do
      icon = "inv_belt_60"
      icon_url = "http://wowarmory.com/wow-icons/_images/43x43/inv_belt_60.png"
      item = Factory(:item, :icon => icon)
      assert_equal icon_url, item.icon
    end

    should "return a 64x64 image URL" do
      icon = "inv_belt_60"
      large_icon_url = "http://wowarmory.com/wow-icons/_images/64x64/inv_belt_60.jpg"
      item = Factory(:item, :icon => icon)
      assert_equal large_icon_url, item.icon(:large)
    end
  end

  context "raw_stats" do
    should "slice out the basic stats" do
      expected = {:spirit => 1, :stamina => 1, :intellect => 1, :strength => 1, :agility => 1}
      item = Factory(:item, :bonuses => expected)
      assert_equal expected, item.base_stats
    end
    should "slice out other stats" do
      other_stats = {:crit => 1, :hit => 1, :expertise => 1, :spell_power => 1, :attack_power => 1}
      item = Factory(:item, :bonuses => other_stats)
      assert_equal({}, item.base_stats)
    end
  end

  should "show ranged weapon info" do
    item = Factory(:ranged_weapon, :bonuses => {:ranged_attack_speed => 3.5, :ranged_min_damage => 200, :ranged_max_damage => 300, :ranged_dps => 100.0})
    assert_equal "200-300 Dmg", item.damage_range
  end

  context "usable_in_same_slot_as" do
    should "find all items in the same slot" do
      item = Factory(:item, :slot => "Head")
      Factory(:item, :slot => "Wrist")
      assert_equal [item], Item.usable_in_same_slot_as(item)
    end
  end

  should "know how much the item costs" do
    item = Factory(:frost_emblem_source).item
    assert_equal 60, item.token_cost
  end

  context "usable_by" do
    should "know that a rogue cannot use staffs" do
      rogue = Factory(:a_rogue)
      mace = Factory(:item, :slot => "Main Hand", :armor_type => ArmorType.mace)
      staff = Factory(:item, :slot => "Two-Hand", :armor_type => ArmorType.staff)
      assert_equal [mace], Item.usable_by(rogue.wow_class)
    end

    should "not find common, rare or uncommon items as upgrades" do
      hunter = Factory(:a_hunter)
      Factory(:item, :quality => "common")
      Factory(:item, :quality => "uncommon")
      Factory(:item, :quality => "rare")
      epic = Factory(:item, :quality => "epic")
      assert_equal [epic], Item.usable_by(hunter.wow_class)
    end

    should "know that a rogue cannot use maces" do
      hunter = Factory(:a_hunter)
      mace = Factory(:item, :slot => "Main Hand", :armor_type => ArmorType.mace)
      staff = Factory(:item, :slot => "Two-Hand", :armor_type => ArmorType.staff)
      assert_equal [staff], Item.usable_by(hunter.wow_class)
    end

    should_eventually "know thata rogue cannot use 2h maces" do
      rogue = Factory(:a_rogue)
      mace = Factory(:item, :slot => "Main Hand", :armor_type => ArmorType.mace)
      two_handed_mace = Factory(:item, :slot => "Two-Hand", :armor_type => ArmorType.mace)
      assert_equal [mace], Item.usable_by(rogue.wow_class)
    end

  end

  context "gems" do
    should "only find gems" do
      gem_item = Factory(:gem)
      Factory(:item)
      assert_equal [gem_item], GemItem.all
    end
  end
end
