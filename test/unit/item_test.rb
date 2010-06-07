require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase
  
  context "change_in_stats_from" do
    should "return the change in stats between two items" do
      old_item = Factory(:item, :bonuses => {:attack_power => 100.0, :spell_power => 45, :stamina => 20})
      new_item = Factory(:item, :bonuses => {:attack_power => 200.0, :stamina => 10.0, :dodge => 20})
      expected_difference = {:attack_power => 100.0, :stamina => -10.0, :spell_power => -45.0, :dodge => 20}
      assert_equal expected_difference, new_item.change_in_stats_from(old_item)
    end
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
end
