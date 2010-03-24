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

    should "find upgrades of the Miscellaneous armor type for any character" do
      rogue = Factory(:a_rogue)
      leather_upgrade = Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 500.0}, :inventory_type => 2, :armor_type => ArmorType.Miscellaneous)
      assert_equal 1, rogue.top_3_triumph_upgrades.size
      assert_equal leather_upgrade, rogue.top_3_triumph_upgrades.first.new_item
    end


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

  context "top_3_heroic_dungeon_upgrades" do
    should "return three upgrades" do
      character = Factory(:character_item, :item => Factory(:item, :inventory_type => 2, :bonuses => {:attack_power => 100.0})).character
      4.times { Factory(:item_from_heroic_dungeon, :bonuses => {:attack_power => 500.0}, :inventory_type => 2) }
      upgrades = character.top_3_heroic_dungeon_upgrades
      assert_equal 3, upgrades.size
      upgrades.each do |upgrade|
        assert_kind_of Upgrade, upgrade
      end
    end
  end
  
  context "find_by_name_or_create_from_wowarmory" do
    should "find character by name and realm" do
      assert_difference "Character.count" do
        rails = Character.find_by_name_and_realm_or_create_from_wowarmory("Rails", "Baelgun")
        assert_equal "Rails", rails.name
        assert_equal "Baelgun", rails.realm
      end
    end
  end
  #this should go to a hunter dps forumla class eventually, it's own model
  context "convert_bonuses_to_dps" do
    setup do
      test_multipliers = {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}
      WowClass::WowClassConstants::Rogue.stubs(:stat_multipliers).returns(test_multipliers)
    end
    should "attack power should be worth 0.5 dps" do
      assert_equal 65.0, Factory(:a_rogue).dps_for(:attack_power => 130)
    end

    should "agility should be worth 1 dps" do
      assert_equal 89.0, Factory(:a_rogue).dps_for(:agility => 89)
    end

    should "hit should be worth 0.8 dps" do
      assert_equal 40.0, Factory(:a_rogue).dps_for(:hit => 50)
    end

    should "haste should be worth 0.7 dps" do
      assert_equal 35.0, Factory(:a_rogue).dps_for(:haste => 50)
    end

    should "crit should be worth 0.75 dps" do
      assert_equal 37.5, Factory(:a_rogue).dps_for(:crit => 50)
    end

    should "armor_penetration should be worth 1.1 dps" do
      assert_equal 55, Factory(:a_rogue).dps_for(:armor_penetration => 50).to_i
    end

  end

  context "dps" do
    should "know the relative dps for a item" do
      assert_equal 191.6, Factory(:a_rogue).dps_for(:attack_power => 130, :agility => 89, :hit => 47, :stamina => 76)
    end
  end

  context "primary_spec" do
    should "be used to determine the characters multipliers" do
      survival_hunter = Factory(:survival_hunter)
      marks_hunter = Factory(:marksmanship_hunter)
      item = Factory(:item)
      assert_not_equal marks_hunter.dps_for(item.bonuses), survival_hunter.dps_for(item.bonuses)
    end
  end
end
