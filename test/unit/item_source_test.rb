require File.dirname(__FILE__) + '/../test_helper'

class ItemSourceTest < ActiveSupport::TestCase
  context "from_emblem_of_triumph" do
    should "find all items that can be purchased with emblem_of_triumph" do
      item_from_emblem_of_triumph = Factory(:item_from_emblem_of_triumph)
      Factory(:item)
      assert_equal [item_from_emblem_of_triumph], Item.from_item_source(EmblemSource.from_emblem_of_triumph)
    end
  end

  context "from_emblem_of_frost" do
    should "find all items that can be purchased with emblem_of_triumph" do
      item_from_emblem_of_frost = Factory(:item_from_emblem_of_frost)
      Factory(:item)
      assert_equal [item_from_emblem_of_frost], Item.from_item_source(EmblemSource.from_emblem_of_frost)
    end
  end
  
  context "from_heroic_dungeon" do
    should "find all items that are dropped inside a heroic dungeon" do
      item = Factory(:item_from_heroic_dungeon)
      Factory(:item)
      assert_equal [item], Item.from_item_source(DroppedSource.from_dungeons)
    end
    
    should "not find items that are dropped inside a heroic raid" do
      Factory(:item_from_heroic_raid)
      assert_equal [], Item.from_item_source(DroppedSource.from_dungeons)
    end
    
  end
  
end

class DroppedSourceTest < ActiveSupport::TestCase
  context "associations" do
    should_belong_to :source_area
  end
end