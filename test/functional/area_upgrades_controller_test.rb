require File.dirname(__FILE__) + '/../test_helper'

class AreaUpgradesControllerTest < ActionController::TestCase
  context "get show" do
    should "show all of a 25 man raids upgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      dropped_source = Factory(:upgrade_from_10_raid, :character => character).new_item_source
      Factory(:upgrade_from_25_raid, :character => character)
      get :show, :character_id => character.id, :id => dropped_source.source_area.id
      assert_response :success
      assert_select ".upgrade", :count => 1
      assert_select ".upgrade_section", :count => 1
    end

    should "paginate" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      dropped_source = Factory(:upgrade_from_10_raid, :character => character).new_item_source
      13.times {Factory(:upgrade_from_10_raid, :character => character, :new_item_source => dropped_source)}
      get :show, :character_id => character.id, :id => dropped_source.source_area.id
      assert_select ".upgrade", :count => 12
      assert_select ".pagination"
      get :show, :character_id => character.id, :id => dropped_source.source_area.id, :page => 2
      assert_select ".upgrade", :count => 2
      assert_select ".pagination"
    end

  end
end
