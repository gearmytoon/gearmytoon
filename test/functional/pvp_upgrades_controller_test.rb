require File.dirname(__FILE__) + '/../test_helper'

class PvpUpgradesControllerTest < ActionController::TestCase
  context "get frost" do
    should "show all upgrades from emblems of frost" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_emblem_of_frost)}
      Factory(:item_from_emblem_of_triumph)
      get :frost, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end

  context "get arena" do
    should "show all upgrades from emblems of frost" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_arena_points)}
      Factory(:item_from_honor_points)
      get :arena, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end

  context "get triumph" do
    should "show all upgrades from emblems of frost" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_emblem_of_triumph)}
      Factory(:item_from_emblem_of_frost)
      get :triumph, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end
  
  context "get honor" do
    should "show all upgrades from honor points" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_honor_points)}
      Factory(:item_from_emblem_of_frost)
      get :honor, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end
  
  context "get wintergrasp" do
    should "show all upgrades from honor points" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_wintergrasp_marks)}
      Factory(:item_from_emblem_of_frost)
      get :wintergrasp, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end
end
