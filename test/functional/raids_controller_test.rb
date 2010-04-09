require File.dirname(__FILE__) + '/../test_helper'

class RaidsControllerTest < ActionController::TestCase
  context "get index" do
    should "show links to all raid zones" do
      character = Factory(:a_rogue)
      Factory(:raid)
      Factory(:dungeon)
      get :index, :character_id => character.id
      assert_response :success
      assert_select ".zone_upgrade", :count => 1
    end
  end

  context "get show" do
    should "show the upgrades from a zone" do
      character = Factory(:character_item, :character => Factory(:a_rogue)).character
      Factory(:item_from_heroic_dungeon)
      item = Factory(:item_from_heroic_raid)
      get :show, :character_id => character.id, :id => item.source_area.id
      assert_response :success
      assert_select ".upgrade", :count => 1
    end
    
  end
end
