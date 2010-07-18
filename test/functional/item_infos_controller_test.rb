require File.dirname(__FILE__) + '/../test_helper'

class ItemInfosControllerTest < ActionController::TestCase
  context "get show" do
    should "show base stats" do
      item = Factory(:item, :bonuses => {:agility => 1, :stamina => 1})
      get :show, :id => item.wowarmory_item_id
      assert_select ".base_stat", :text => "+1 Agility"
      assert_select ".base_stat", :text => "+1 Stamina"
    end

    should "show melee weapon info" do
      item = Factory(:item, :bonuses => {:melee_attack_speed => 3.5, :melee_min_damage => 200, :melee_max_damage => 300, :melee_dps => 100.0})
      get :show, :id => item.wowarmory_item_id
      assert_select ".min_max_damage", :text => "200-300 Dmg"
      assert_select ".attack_speed", :text => "Speed 3.5"
      assert_select ".dps_description", :text => "(100.0 damage per second)"
    end

    should "show ranged weapon info" do
      item = Factory(:item, :bonuses => {:ranged_attack_speed => 3.5, :ranged_min_damage => 200, :ranged_max_damage => 300, :ranged_dps => 100.0})
      get :show, :id => item.wowarmory_item_id
      assert_select ".min_max_damage", :text => "200-300 Dmg"
      assert_select ".attack_speed", :text => "Speed 3.5"
      assert_select ".dps_description", :text => "(100.0 damage per second)"
    end

    should "not show attack speed etc in the equipped stats section" do
      item = Factory(:item, :bonuses => {:ranged_attack_speed => 3.5, :ranged_min_damage => 200, :ranged_max_damage => 300, :ranged_dps => 100.0})
      get :show, :id => item.wowarmory_item_id
      assert_select ".equip_stat", :count => 0
    end

    should "show equipped stats section" do
      item = Factory(:item, :bonuses => {:spell_power => 105, :mana_regen => 72})
      get :show, :id => item.wowarmory_item_id
      assert_select ".equip_stat", :count => 2
      assert_select ".equip_stat", :text => "Equip: Increases your spell power by 105"
      assert_select ".equip_stat", :text => "Equip: Restores 72 mana per 5 secs"
    end

    should "show item name" do
      item = Factory(:item, :name => "Foo of Foo")
      get :show, :id => item.wowarmory_item_id
      assert_select ".item_name", :text => "Foo of Foo"
    end
    
    should "show restricted to" do
      item = Factory(:item, :restricted_to => "Hunter")
      get :show, :id => item.wowarmory_item_id
      assert_select ".restricted_to", :text => "Hunter"
    end
    
    should "not show restricted to NONE" do
      item = Factory(:item, :restricted_to => Item::RESTRICT_TO_NONE)
      get :show, :id => item.wowarmory_item_id
      assert_select ".restricted_to", :count => 0
    end
    
    should "show item sockets" do
      item = Factory(:item, :gem_sockets => ["Meta", "Blue", "Red"], :socket_bonuses => {:agility => 4})
      get :show, :id => item.wowarmory_item_id
      assert_select ".socket-meta", :text => "Meta Socket", :count => 1
      assert_select ".socket-blue", :text => "Blue Socket", :count => 1
      assert_select ".socket-red", :text => "Red Socket", :count => 1
      assert_select ".socket_bonuses", :text => "Socket Bonus: +4 Agility", :count => 1
    end

    should "show item slot name" do
      item = Factory(:item, :name => "Foo of Foo", :slot => "Helm")
      get :show, :id => item.wowarmory_item_id
      assert_select ".item_slot", :text => "Helm"
      assert_select ".armor_type", :text => "Mail"
    end

    should "show item bonding" do
      item = Factory(:item, :name => "Foo of Foo", :slot => "Helm")
      get :show, :id => item.wowarmory_item_id
      assert_select ".bonding", :text => "Binds when picked up"
    end

    should "show item armor" do
      item = Factory(:item, :bonuses => {:armor => 1})
      get :show, :id => item.wowarmory_item_id
      assert_select ".armor", :text => "1 Armor"
    end

    should "not show item armor if there is none" do
      item = Factory(:item, :bonuses => {})
      get :show, :id => item.wowarmory_item_id
      assert_select ".armor", :count => 0
    end
    
  end
end