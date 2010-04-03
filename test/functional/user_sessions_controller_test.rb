require File.dirname(__FILE__) + '/../test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  context "post #create" do
    should "create an admin session for an admin user" do
      admin = Factory(:admin)
      post :create, :user_session => {:email => 'admin@gearmytoon.com', :password => 'password'}
      assert_equal :admin, assigns(:user_session).id
    end

    should "not create an admin session for a normal user" do
      user = Factory(:user)
      post :create, :user_session => {:email => 'foo@foo.com', :password => 'password'}
      assert_nil assigns(:user_session).id
    end

    should "create a normal session for a normal user" do
      Factory(:user)
      post :create, :user_session => {:email => 'foo@foo.com', :password => 'password'}
      assert_nil assigns(:user_session).id
    end
  end

  context "delete #destroy" do
    setup { activate_authlogic }

    should "remove the admin session" do
      Factory(:admin)
      delete :destroy
      assert_nil UserSession.find(:admin)
    end

    should "remove the user session" do
      Factory(:user)
      delete :destroy
      assert_nil UserSession.find
    end
  end
end
