require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase
  should_belong_to :source_area

  context "with_same_inventory_type" do
    should "treat crossbows, bows, guns, and thrown the same" do
      Factory(:item, :inventory_type => 25)#thrown
      xbow = Factory(:item, :inventory_type => 15)#bow
      Factory(:item, :inventory_type => 26)#gun/xbow
      assert_equal 3, Item.with_same_inventory_type(xbow).length
    end
  end

  context "from_emblem_of_triumph" do
    should "find all items that can be purchased with emblem_of_triumph" do
      item_from_emblem_of_triumph = Factory(:item_from_emblem_of_triumph)
      Factory(:item)
      assert_equal [item_from_emblem_of_triumph], Item.from_emblem_of_triumph
    end
  end

  context "from_emblem_of_frost" do
    should "find all items that can be purchased with emblem_of_triumph" do
      item_from_emblem_of_frost = Factory(:item_from_emblem_of_frost)
      Factory(:item)
      assert_equal [item_from_emblem_of_frost], Item.from_emblem_of_frost
    end
  end
  
  context "from_heroic_dungeon" do
    should "find all items that are dropped inside a heroic dungeon" do
      item = Factory(:item_from_heroic_dungeon)
      Factory(:item)
      assert_equal [item], Item.from_heroic_dungeon
    end
    
    should "not find items that are dropped inside a heroic raid" do
      Factory(:item_from_heroic_raid)
      assert_equal [], Item.from_heroic_dungeon
    end
    
  end

  context "dps_compared_to_for_character" do
    setup do
      test_multipliers = {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}
      WowClass::WowClassConstants::Rogue.stubs(:stat_multipliers).returns(test_multipliers)
    end

    should "return the difference in dps with what the character is wearing" do
      fifty_dps = Factory(:item, :inventory_type => 0, :bonuses => {:attack_power => 100.0})
      one_hundred_dps = Factory(:item, :inventory_type => 0, :bonuses => {:attack_power => 200.0})
      assert_equal 50.0, one_hundred_dps.dps_compared_to_for_character(fifty_dps, Factory(:a_rogue))
    end
  end
  
  context "change_in_stats_from" do
    should "return the change in stats between two items" do
      old_item = Factory(:item, :inventory_type => 0, :bonuses => {:attack_power => 100.0, :spell_power => 45, :stamina => 20})
      new_item = Factory(:item, :inventory_type => 0, :bonuses => {:attack_power => 200.0, :stamina => 10.0, :dodge => 20})
      expected_difference = {:attack_power => 100.0, :stamina => -10.0, :spell_power => -45.0, :dodge => 20}
      assert_equal expected_difference, new_item.change_in_stats_from(old_item)
    end
  end

  context "in_same_slot_as" do
    should "find all items in the same slot" do
      item = Factory(:item, :inventory_type => 0)
      Factory(:item, :inventory_type => 1)
      assert_equal [item], Item.with_same_inventory_type(item)
    end
  end

end
