require File.dirname(__FILE__) + '/../test_helper'

class CharactersControllerTest < ActionController::TestCase
  context "get show" do
    should "display character info" do
      get :show, :id => "merb"
      assert_response :success
      assert_select "#character_name", :text => "Merb"
    end
  end
end
