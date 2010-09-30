require File.dirname(__FILE__) + '/../test_helper'

class CreaturesControllerTest < ActionController::TestCase
  context "get show" do
    should "show creatures name" do
      creature = Factory(:creature, :name => "Kevin Sorbo")
      get :show, :id => creature.id
      assert_select ".creature .name", :text => "Kevin Sorbo"
    end

    should "show level range" do
      creature = Factory(:creature, :min_level => 1, :max_level => 83)
      get :show, :id => creature.id
      assert_select ".creature .level_range", :text => "1-83"
    end

    should "show dropped items type and difficulty" do
      creature = Factory(:creature)
      Factory(:dungeon_dropped_source, :creature => creature, :item => Factory(:item, :armor_type => ArmorType.mail, :slot => "Helm", :name => "Something"))
      get :show, :id => creature.id
      assert_select ".item_dropped .item_type", :text => "Mail Helm"
      assert_select ".item_dropped .difficulty", :text => "Normal 10"
    end
    
    should "show items dropped by" do
      creature = Factory(:creature)
      Factory(:dungeon_dropped_source, :creature => creature, :item => Factory(:item, :name => "Something"))
      get :show, :id => creature.id
      assert_select ".item_dropped .item_name", :text => "Something"
    end
    
    should "show all items dropped by" do
      creature = Factory(:creature)
      2.times{Factory(:dungeon_dropped_source, :creature => creature)}
      get :show, :id => creature.id
      assert_select ".creature .item_dropped", :count => 2
    end
    
    should "show classification" do
      creature = Factory(:creature, :classification => "3")
      get :show, :id => creature.id
      assert_select ".creature .classification", :text => "Boss"
    end
    
    should "show area found in" do
      creature = Factory(:creature, :area => Factory(:dungeon, :name => "That Place Over There"))
      get :show, :id => creature.id
      assert_select ".creature .area .name", :text => "That Place Over There"
      assert_select ".creature .found_in", :text => "That Place Over There"
    end
    
    should "show other drops from the same boss" do
      area_25 = Factory(:heroic_raid_25, :wowarmory_area_id => Area::RAIDS.last, :name => "That Place Over There")
      area_10 = Factory(:raid_10, :wowarmory_area_id => Area::RAIDS.last, :name => "That Place Over There")
      bob_25 = Factory(:boss, :name => "bob", :area => area_25)
      Factory(:dungeon_dropped_source, :creature => bob_25)
      bob_10 = Factory(:boss, :name => "bob", :area => area_10)
      Factory(:dungeon_dropped_source, :creature => bob_10)
      get :show, :id => bob_25.id
      assert_select ".creature .item_dropped", :count => 2
    end
    
    should "dropped items source difficulty" do
      area_25 = Factory(:heroic_raid_25, :wowarmory_area_id => Area::RAIDS.last, :name => "That Place Over There")
      area_10 = Factory(:raid_10, :wowarmory_area_id => Area::RAIDS.last, :name => "That Place Over There")
      bob_25 = Factory(:boss, :name => "bob", :area => area_25)
      Factory(:dungeon_dropped_source, :creature => bob_25)
      bob_10 = Factory(:boss, :name => "bob", :area => area_10)
      Factory(:dungeon_dropped_source, :creature => bob_10)
      get :show, :id => bob_25.id
      assert_select ".creature .difficulty", :text => "Heroic 25"
      assert_select ".creature .difficulty", :text => "Normal 10"
    end

    should "show other bosses in the same area if is a boss and in a raid/dungeon" do
      area_25 = Factory(:heroic_raid_25, :wowarmory_area_id => Area::RAIDS.last, :name => "That Place Over There")
      area_10 = Factory(:raid_10, :wowarmory_area_id => Area::RAIDS.last, :name => "That Place Over There")
      bob_25 = Factory(:boss, :name => "bob", :area => area_25)
      Factory(:boss, :name => "bob", :area => area_10)
      Factory(:boss, :name => "bob's brother", :area => area_25)
      Factory(:boss, :name => "bob's brother", :area => area_10)
      get :show, :id => bob_25.id
      assert_select ".creature .area .other_creature", :count => 2
      assert_select ".creature .area .other_creature", :text => "bob"
      assert_select ".creature .area .other_creature", :text => "bob's brother"
    end

    should "show not show non boss creatures in a raid/dungeon" do
      area_10 = Factory(:raid_10, :wowarmory_area_id => Area::RAIDS.last, :name => "That Place Over There")
      bob = Factory(:boss, :name => "bob", :area => area_10)
      Factory(:raid_10_creature, :name => "a creature", :area => area_10)
      get :show, :id => bob.id
      assert_select ".creature .area .other_creature", :count => 1
      assert_select ".creature .area .other_creature", :text => "bob"
      assert_select ".creature .area .other_creature", :text => "a creature", :count => 0
    end

  end
end
