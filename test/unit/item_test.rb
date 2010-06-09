require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase
  
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
  
  context "gems" do
    should "only find gems" do
      gem_item = Factory(:gem)
      Factory(:item)
      assert_equal [gem_item], GemItem.all
    end
  end
end
