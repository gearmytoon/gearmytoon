require File.dirname(__FILE__) + '/../test_helper'

class HomesControllerTest < ActionController::TestCase
  context "get show" do
    should "respond with success" do
      get :show
      assert_response :success
    end
  end
  context "get no_such_character" do
    should "respond with success" do
      get :no_such_character, :name => "Zerb", :realm => "Baelgun"
      assert_response :success
      assert_select "#error .message", :text => "Sorry we could not locate the character Zerb on Baelgun, please ensure the spelling is correct."
    end
  end
end
