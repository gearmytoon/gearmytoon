require File.dirname(__FILE__) + '/../test_helper'

class ItemSourceTest < ActiveSupport::TestCase
  context "from_emblem_of_triumph" do
    should "find all items that can be purchased with emblem_of_triumph" do
      triumph_source = Factory(:triumph_emblem_source)
      Factory(:frost_emblem_source)
      assert_equal [triumph_source], EmblemSource.from_emblem_of_triumph
    end
  end

  context "from_emblem_of_frost" do
    should "find all items that can be purchased with emblem_of_triumph" do
      frost_source = Factory(:frost_emblem_source)
      Factory(:triumph_emblem_source)
      assert_equal [frost_source], EmblemSource.from_emblem_of_frost
    end
  end
  
  context "from_heroic_dungeon" do
    should "find all items that are dropped inside a heroic dungeon" do
      item_source = Factory(:dungeon_dropped_source)
      Factory(:frost_emblem_source)
      assert_equal [item_source], DroppedSource.from_dungeons
    end
    
    should "not find items that are dropped inside a heroic raid" do
      Factory(:raid_dropped_source)
      assert_equal [], DroppedSource.from_dungeons
    end
  end
  should "delete upgrades with item source" do
    upgrade = Factory(:upgrade)
    assert_difference "Upgrade.count", -1 do
      assert_difference "ItemSource.count", -1 do
        upgrade.new_item_source.destroy
      end
    end
  end
  
end

class DroppedSourceTest < ActiveSupport::TestCase
  context "associations" do
    should_belong_to :source_area
  end
  context "from_area" do
    should "find all items that are dropped inside a heroic dungeon" do
      dropped_source = Factory(:dungeon_dropped_source)
      Factory(:raid_dropped_source)
      assert_equal [dropped_source], DroppedSource.from_area(dropped_source.source_area)
    end
  end
end
