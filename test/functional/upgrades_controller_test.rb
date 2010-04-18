require File.dirname(__FILE__) + '/../test_helper'

class UpgradesControllerTest < ActionController::TestCase
  context "get from_frost_emblems" do
    should "show all upgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_emblem_of_frost)}
      Factory(:item_from_emblem_of_triumph)
      get :from_frost_emblems, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end

  context "get from_triumph_emblems" do
    should "show all upgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_emblem_of_triumph)}
      Factory(:item_from_emblem_of_frost)
      get :from_triumph_emblems, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end

  context "get from_dungeons" do
    should "show all upgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_heroic_dungeon)}
      Factory(:item_from_emblem_of_frost)
      get :from_dungeons, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end
  
  context "get from_25_man_raids" do
    should_eventually "show all upgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      Factory(:item_from_25_man_raids)
      Factory(:item_from_10_man_raids)
      get :from_25_man_raids, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 1
    end
  end

  context "get from_10_man_raids" do
    should_eventually "show all upgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      Factory(:item_from_10_man_raids)
      Factory(:item_from_25_man_raids)
      get :from_10_man_raids, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 1
    end
  end

end
