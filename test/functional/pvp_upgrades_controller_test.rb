require File.dirname(__FILE__) + '/../test_helper'

class PvpUpgradesControllerTest < ActionController::TestCase
  context "get from_frost_emblems" do
    should "show all upgrades from emblems of frost" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_emblem_of_frost)}
      Factory(:item_from_emblem_of_triumph)
      get :from_frost_emblems, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end

  context "get from_triumph_emblems" do
    should "show all upgrades from emblems of frost" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_emblem_of_triumph)}
      Factory(:item_from_emblem_of_frost)
      get :from_triumph_emblems, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end
  
  context "get from_honor_points" do
    should "show all upgrades from honor points" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_honor_points)}
      Factory(:item_from_emblem_of_frost)
      get :from_honor_points, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end
  context "get from_wintergrasp_marks" do
    should "show all upgrades from honor points" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_wintergrasp_marks)}
      Factory(:item_from_emblem_of_frost)
      get :from_wintergrasp_marks, :character_id => character.id
      assert_response :success
      assert_select "#wintergrasp_mark_of_honor .upgrade", :count => 4
    end
  end
end
