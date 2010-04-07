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

  context "post #rpx_create" do
    setup do
      data = {:identifier => 'foo', :email => 'foo@bar.com'}
      RPXNow.stubs(:user_data).returns(data)
      @invite = Factory(:invite)
    end

    should "require a valid invite token to create a new user" do
      post :rpx_create, :invite => {:token => @invite.token}
      assert !assigns(:user).new_record?
    end

    should "not create a new user with an invalid invite token" do
      post :rpx_create, :invite => {:token => 'snatheuo'}
      assert assigns(:user).new_record?
    end

    should "create a user without an e-mail address" do
      data = {:identifier => 'http://foo.com', :email => nil}
      RPXNow.stubs(:user_data).returns(data)
      post :rpx_create, :invite => {:token => @invite.token}
      assert !assigns(:user).new_record?
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
