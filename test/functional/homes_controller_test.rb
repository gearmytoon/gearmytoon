require File.dirname(__FILE__) + '/../test_helper'

class HomesControllerTest < ActionController::TestCase
  context "get show" do
    should "respond with success" do
      get :show
      assert_response :success
    end
  end
end
