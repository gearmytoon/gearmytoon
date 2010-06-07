require File.dirname(__FILE__) + '/../test_helper'

class AreaUpgradesControllerTest < ActionController::TestCase
  context "get show" do
    should_eventually "show all of a 25 man raids upgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      dropped_source = Factory(:upgrade_from_10_raid, :character => character).new_item_source
      Factory(:upgrade_from_25_raid, :character => character)
      get :show, :character_id => character.id, :id => dropped_source.source_area.id
      assert_response :success
      assert_select ".upgrade", :count => 1
      assert_select ".upgrade_section", :count => 1
    end
  end
end
