require File.dirname(__FILE__) + '/../test_helper'

class DungeonsControllerTest < ActionController::TestCase
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
end
