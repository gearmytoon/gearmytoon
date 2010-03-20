require File.dirname(__FILE__) + '/../test_helper'

class UpgradesControllerTest < ActionController::TestCase
  context "get from_frost_emblems" do
    should "show all upgrades from emblems of frost" do
      character = Factory(:a_hunter)
      4.times {Factory(:item_from_emblem_of_frost)}
      Factory(:item_from_emblem_of_triumph)
      get :from_frost_emblems, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end

  context "get from_triumph_emblems" do
    should "show all upgrades from emblems of frost" do
      character = Factory(:a_hunter)
      4.times {Factory(:item_from_emblem_of_triumph)}
      Factory(:item_from_emblem_of_frost)
      get :from_triumph_emblems, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end

end
