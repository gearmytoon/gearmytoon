require File.dirname(__FILE__) + '/../test_helper'

class UpgradesControllerTest < ActionController::TestCase
  context "get frost" do
    should "display the buy this character if the character not paid for" do
      character = Factory(:unpaid_character)
      get :frost, :character_id => character.friendly_id
      assert_select "#unpaid_character"
    end
    
    should "show all upgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_emblem_of_frost)}
      Factory(:item_from_emblem_of_triumph)
      get :frost, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
    
    should "show frost downgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      downgrade = Factory(:downgrade_item_from_frost_emblem)
      get :frost, :character_id => character.id
      assert_response :success
      assert_select ".downgrade", :count => 1
    end
  end

  context "get triumph" do
    should "show all upgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_emblem_of_triumph)}
      Factory(:item_from_emblem_of_frost)
      get :triumph, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end

  context "get dungeon" do
    should "show all upgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      4.times {Factory(:item_from_heroic_dungeon)}
      Factory(:item_from_emblem_of_frost)
      get :dungeon, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end
  
  context "get raid_25" do
    should "show all 25 man raids upgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      2.times{Factory(:item_from_25_man_raid)}
      Factory(:item_from_10_man_raid)
      get :raid_25, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 2
      assert_select ".upgrade_section", :count => 2
    end
  end

  context "get raid_10" do
    should "show all upgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      2.times{Factory(:item_from_10_man_raid)}
      Factory(:item_from_25_man_raid)
      get :raid_10, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 2
      assert_select ".upgrade_section", :count => 2
    end
  end

end
