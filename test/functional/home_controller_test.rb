require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase
  context "get index" do
    should "respond with success" do
      get :show
      assert_response :success
    end
  end

  context "get contact" do
    should "respond with success" do
      get :contact
      assert_response :success
    end
  end
end
