require File.dirname(__FILE__) + '/../test_helper'

class CharacterTest < ActiveSupport::TestCase
  context "associations" do
    should_have_many :equipped_items
    should_have_many :character_items
    should_belong_to :wow_class
    should "have many equipped items through character_items" do
      character_item = Factory(:character_item)
      assert_equal [character_item.item], character_item.character.equipped_items
    end
  end

  context "top_3_frost_upgrades" do
    
    should "find upgrades of the same armor type" do
      rogue = Factory(:a_rogue)
      plate_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :inventory_type => 2, :armor_type => ArmorType.Plate)
      leather_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :inventory_type => 2, :armor_type => ArmorType.Leather)
      assert_equal 1, rogue.top_3_frost_upgrades.size
      assert_equal leather_upgrade, rogue.top_3_frost_upgrades.first.new_item
    end

    should "find a upgrade if you do not have a inventory item in that slot" do
      character = Factory(:character)
      upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :inventory_type => 2)
      assert_equal upgrade, character.top_3_frost_upgrades.first.new_item
    end
    
    should "order the upgrades by the dps increase" do
      character = Factory(:character_item, :item => Factory(:item, :inventory_type => 2, :bonuses => {:attack_power => 100.0})).character
      mid_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 200.0}, :inventory_type => 2)
      upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :inventory_type => 2)
      upgrades = [upgrade, mid_upgrade]
      assert_equal upgrades.map(&:id), character.top_3_frost_upgrades.map(&:new_item).map(&:id)
    end

    should "find a characters upgrades from frost badges" do
      character = Factory(:character_item, :item => Factory(:item, :inventory_type => 2, :bonuses => {:attack_power => 100.0})).character
      Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 50.0}, :inventory_type => 2)
      upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :inventory_type => 2)
      assert_equal 1, character.top_3_frost_upgrades.length
      assert_equal upgrade, character.top_3_frost_upgrades.first.new_item
    end

    should "find the first 3 upgrades" do
      character = Factory(:character_item, :item => Factory(:item, :inventory_type => 2, :bonuses => {:attack_power => 100.0})).character
      4.times { Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :inventory_type => 2) }
      assert_equal 3, character.top_3_frost_upgrades.length
    end
  end

  context "top_3_triumph_upgrades" do

    should "find upgrades of the same armor type" do
      rogue = Factory(:a_rogue)
      plate_upgrade = Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 500.0}, :inventory_type => 2, :armor_type => ArmorType.Plate)
      leather_upgrade = Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 500.0}, :inventory_type => 2, :armor_type => ArmorType.Leather)
      assert_equal 1, rogue.top_3_triumph_upgrades.size
      assert_equal leather_upgrade, rogue.top_3_triumph_upgrades.first.new_item
    end

    should "order the upgrades by the dps increase" do
      character = Factory(:character_item, :item => Factory(:item, :inventory_type => 2, :bonuses => {:attack_power => 100.0})).character
      mid_upgrade = Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 200.0}, :inventory_type => 2)
      upgrade = Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 500.0}, :inventory_type => 2)
      upgrades = [upgrade, mid_upgrade]
      assert_equal upgrades.map(&:id), character.top_3_triumph_upgrades.map(&:new_item).map(&:id)
    end

    should "find a characters upgrades from frost badges" do
      character = Factory(:character_item, :item => Factory(:item, :inventory_type => 2, :bonuses => {:attack_power => 100.0})).character
      Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 50.0}, :inventory_type => 2)
      upgrade = Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 500.0}, :inventory_type => 2)
      assert_equal 1, character.top_3_triumph_upgrades.length
      assert_equal upgrade, character.top_3_triumph_upgrades.first.new_item
    end

    should "find the first 3 upgrades" do
      character = Factory(:character_item, :item => Factory(:item, :inventory_type => 2, :bonuses => {:attack_power => 100.0})).character
      4.times { Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 500.0}, :inventory_type => 2) }
      assert_equal 3, character.top_3_triumph_upgrades.length
    end
  end

end
