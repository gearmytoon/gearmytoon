require File.dirname(__FILE__) + '/../test_helper'

class CharacterRefreshesControllerTest < ActionController::TestCase
  context "get show" do
    should "respond with new status" do
      character_refresh = Factory(:character_refresh)
      get :show, :id => character_refresh.id, :format => "json"
      refresh_response = JSON.parse(@response.body)
      assert_response :success
      assert_equal "new", refresh_response['status']
    end
    should "respond with done status" do
      character_refresh = Factory(:character_refresh)
      character_refresh.found!
      get :show, :id => character_refresh.id, :format => "json"
      refresh_response = JSON.parse(@response.body)
      assert_response :success
      assert_equal "done", refresh_response['status']
    end
  end
end
