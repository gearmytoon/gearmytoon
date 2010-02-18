require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase
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

  context "dps_compared_to" do
    should "return the difference in dps with what the character is wearing" do
      fifty_dps = Factory(:item, :inventory_type => 0, :dps => 50.0)
      one_hundred_dps = Factory(:item, :inventory_type => 0, :dps => 100.0)
      assert_equal 50.0, one_hundred_dps.dps_compared_to(fifty_dps)
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
