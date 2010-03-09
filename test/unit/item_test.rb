require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase
  should_belong_to :area

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
  end

  context "dps_compared_to" do
    should "return the difference in dps with what the character is wearing" do
      fifty_dps = Factory(:item, :inventory_type => 0, :bonuses => {:attack_power => 100.0})
      one_hundred_dps = Factory(:item, :inventory_type => 0, :bonuses => {:attack_power => 200.0})
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

  #this should go to a hunter dps forumla class eventually, it's own model
  context "convert_bonuses_to_dps" do
    should "attack power should be worth 0.5 dps" do
      item = Factory(:item, :bonuses => {:attack_power => 130})
      assert_equal 65.0, item.dps
    end

    should "agility should be worth 1 dps" do
      item = Factory(:item, :bonuses => {:agility => 89})
      assert_equal 89.0, item.dps
    end

    should "hit should be worth 0.8 dps" do
      item = Factory(:item, :bonuses => {:hit => 50})
      assert_equal 40.0, item.dps
    end

    should "haste should be worth 0.7 dps" do
      item = Factory(:item, :bonuses => {:haste => 50})
      assert_equal 35.0, item.dps
    end

    should "crit should be worth 0.75 dps" do
      item = Factory(:item, :bonuses => {:crit => 50})
      assert_equal 37.5, item.dps
    end

    should "armor_penetration should be worth 1.1 dps" do
      item = Factory(:item, :bonuses => {:armor_penetration => 50})
      assert_equal 55, item.dps.to_i
    end

  end

  context "dps" do
    should "know the relative dps for a item" do
      item = Factory(:item, :bonuses => {:attack_power => 130, :agility => 89, :hit => 47, :stamina => 76})
      assert_equal 191.6, item.dps
    end
  end

end
