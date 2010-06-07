require File.dirname(__FILE__) + '/../test_helper'

class PvpUpgradesControllerTest < ActionController::TestCase
  context "get frost" do
    should "show all upgrades from emblems of frost" do
      character = Factory(:a_hunter)
      4.times {Factory(:upgrade_from_emblem_of_frost, :character => character)}
      Factory(:upgrade_from_emblem_of_triumph, :character => character)
      get :frost, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end

  context "get arena" do
    should "show all upgrades from emblems of frost" do
      character = Factory(:a_hunter)
      4.times {Factory(:upgrade_from_arena_points, :character => character)}
      Factory(:upgrade_from_honor_points, :character => character)
      get :arena, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end

  context "get triumph" do
    should "show all upgrades from emblems of frost" do
      character = Factory(:a_hunter)
      4.times {Factory(:upgrade_from_emblem_of_triumph, :character => character)}
      Factory(:upgrade_from_emblem_of_frost, :character => character)
      get :triumph, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end
  
  context "get honor" do
    should "show all upgrades from honor points" do
      character = Factory(:a_hunter)
      4.times {Factory(:upgrade_from_honor_points, :character => character)}
      Factory(:upgrade_from_emblem_of_frost, :character => character)
      get :honor, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end
  
  context "get wintergrasp" do
    should "show all upgrades from honor points" do
      character = Factory(:a_hunter)
      4.times {Factory(:upgrade_from_wintergrasp_marks, :character => character)}
      Factory(:upgrade_from_emblem_of_frost, :character => character)
      get :wintergrasp, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end
end
