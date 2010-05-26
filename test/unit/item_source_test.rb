require File.dirname(__FILE__) + '/../test_helper'

class ItemSourceTest < ActiveSupport::TestCase
  context "from_emblem_of_triumph" do
    should "find all items that can be purchased with emblem_of_triumph" do
      item_from_emblem_of_triumph = Factory(:item_from_emblem_of_triumph)
      Factory(:item)
      assert_equal [item_from_emblem_of_triumph], EmblemSource.from_emblem_of_triumph.map(&:item)
    end
  end

  context "from_emblem_of_frost" do
    should "find all items that can be purchased with emblem_of_triumph" do
      item_from_emblem_of_frost = Factory(:item_from_emblem_of_frost)
      Factory(:item)
      assert_equal [item_from_emblem_of_frost], EmblemSource.from_emblem_of_frost.map(&:item)
    end
  end
  
  context "from_heroic_dungeon" do
    should "find all items that are dropped inside a heroic dungeon" do
      item = Factory(:item_from_heroic_dungeon)
      Factory(:item)
      assert_equal [item], DroppedSource.from_dungeons.map(&:item)
    end
    
    should "not find items that are dropped inside a heroic raid" do
      Factory(:item_from_heroic_raid)
      assert_equal [], DroppedSource.from_dungeons.map(&:item)
    end
  end
  
end

class DroppedSourceTest < ActiveSupport::TestCase
  context "associations" do
    should_belong_to :source_area
  end
  context "from_area" do
    should "find all items that are dropped inside a heroic dungeon" do
      item = Factory(:item_from_heroic_dungeon)
      Factory(:item_from_heroic_dungeon)
      assert_equal [item], DroppedSource.from_area(item.dropped_sources.first.source_area).map(&:item)
    end
  end
end
