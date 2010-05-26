require File.dirname(__FILE__) + '/../test_helper'

class AreaUpgradesControllerTest < ActionController::TestCase
  context "get show" do
    should "show all of a 25 man raids upgrades" do
      character = Factory(:character_item, :character => Factory(:a_hunter)).character
      item = Factory(:item_from_25_man_raid)
      Factory(:item_from_10_man_raid)
      get :show, :character_id => character.id, :id => item.dropped_sources.first.source_area.id
      assert_response :success
      assert_select ".upgrade", :count => 1
      assert_select ".upgrade_section", :count => 1
    end
  end
end
