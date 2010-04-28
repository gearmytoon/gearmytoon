require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  context "get #show" do
    setup do
      activate_authlogic
      Factory(:user)
      get :show
    end

    should_assign_to :user
    should_assign_to :character
  end
end
