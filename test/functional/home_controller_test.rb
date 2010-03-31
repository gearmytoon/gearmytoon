require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase
  context "get index" do
    should "respond with success" do
      get :index
      assert_response :success
    end
  end
end
