require File.dirname(__FILE__) + '/../test_helper'

class PaymentsControllerTest < ActionController::TestCase
  context "get show" do
    setup do
      activate_authlogic
      @user = Factory(:user)
    end
    should "respond with success" do
      get :show
      assert_response :success
    end

  end
end
