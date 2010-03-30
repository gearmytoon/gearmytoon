require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase

  context "associations" do
    should_belong_to :source_area
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
  
  context "change_in_stats_from" do
    should "return the change in stats between two items" do
      old_item = Factory(:item, :inventory_type => 0, :bonuses => {:attack_power => 100.0, :spell_power => 45, :stamina => 20})
      new_item = Factory(:item, :inventory_type => 0, :bonuses => {:attack_power => 200.0, :stamina => 10.0, :dodge => 20})
      expected_difference = {:attack_power => 100.0, :stamina => -10.0, :spell_power => -45.0, :dodge => 20}
      assert_equal expected_difference, new_item.change_in_stats_from(old_item)
    end

    should "return new_item's bonuses if the old item is nil" do
      old_item = nil
      new_item = Factory(:item, :inventory_type => 0, :bonuses => {:attack_power => 200.0, :stamina => 10.0, :dodge => 20})
      expected_difference = {:attack_power => 200.0, :stamina => 10.0, :dodge => 20}
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

end
