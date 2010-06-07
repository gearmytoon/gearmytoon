require File.dirname(__FILE__) + '/../test_helper'

class UpgradesControllerTest < ActionController::TestCase
  context "get frost" do
    should "display the buy this character if the character not paid for" do
      character = Factory(:unpaid_character)
      get :frost, :character_id => character.friendly_id
      assert_select "#unpaid_character"
    end
    
    should "show all upgrades" do
      character = Factory(:a_hunter)
      4.times {Factory(:upgrade_from_emblem_of_frost, :character => character)}
      Factory(:upgrade_from_emblem_of_triumph, :character => character)
      get :frost, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
    
    should "show frost downgrades" do
      character = Factory(:a_hunter)
      downgrade_source = Factory(:frost_emblem_source, :item => Factory(:item, :bonuses => {}))
      Factory(:upgrade, :new_item_source => downgrade_source, :character => character)
      get :frost, :character_id => character.id
      assert_response :success
      assert_select ".downgrade", :count => 1
    end
  end

  context "get triumph" do
    should "show all upgrades" do
      character = Factory(:a_hunter)
      4.times {Factory(:upgrade_from_emblem_of_triumph, :character => character)}
      Factory(:upgrade_from_emblem_of_frost, :character => character)
      get :triumph, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end

  context "get dungeon" do
    should "show all upgrades" do
      character = Factory(:a_hunter)
      4.times {Factory(:upgrade_from_heroic_dungeon, :character => character)}
      Factory(:upgrade_from_emblem_of_frost, :character => character)
      get :dungeon, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 4
    end
  end
  
  context "get raid_25" do
    should "show all 25 man raids upgrades" do
      character = Factory(:a_hunter)
      2.times{Factory(:upgrade_from_25_raid, :character => character)}
      Factory(:upgrade_from_10_raid, :character => character)
      get :raid_25, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 2
      assert_select ".upgrade_section", :count => 2
      assert_select ".upgrade_summary_header a", :count => 2
    end
  end

  context "get raid_10" do
    should "show all upgrades" do
      character = Factory(:a_hunter)
      2.times{Factory(:upgrade_from_10_raid, :character => character)}
      Factory(:upgrade_from_25_raid, :character => character)
      get :raid_10, :character_id => character.id
      assert_response :success
      assert_select ".upgrade", :count => 2
      assert_select ".upgrade_section", :count => 2
      assert_select ".upgrade_summary_header a", :count => 2
    end
  end
end
