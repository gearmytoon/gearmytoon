require 'test/test_helper'

class UsersControllerTest < ActionController::TestCase
  context "get #new" do
    should "require a valid invite token" do
      invite = Invite.create(:email => 'foo@bar.com')
      get :new, :invite => {:token => invite.token}
      assert_response :success
    end

    should "redirect to root_url for invalid invite token" do
      invite = Invite.create(:email => 'foo@bar.com')
      get :new
      assert_redirected_to root_url
    end
  end

  context "post #create" do
    should "require a valid invite token" do
      invite = Invite.create(:email => 'foo@bar.com')
      post :create, :user => {:email => 'foo@foo.com', :password => 'password', :password_confirmation => 'password'}, :invite => {:token => invite.token}
      assert_equal "Account registered!", flash[:notice]
      assert_redirected_to account_url
      assert !assigns(:user).new_record?
    end

    should "destroy the invite after user is created successfully" do
      invite = Invite.create(:email => 'foo@bar.com')
      post :create, :user => {:email => 'foo@foo.com', :password => 'password', :password_confirmation => 'password'}, :invite => {:token => invite.token}
      assert_nil Invite.find_by_id(invite.id)
    end

    should "not destroy the invite if the user could not be created successfully" do
      invite = Invite.create(:email => 'foo@bar.com')
      post :create, :user => {:email => 'foo@foo.com', :password => 'password', :password_confirmation => 'drowssap'}, :invite => {:token => invite.token}
      assert_not_nil Invite.find_by_id(invite.id)
    end

    should "redirect to root_url for invalid invite token" do
      invite = Invite.create(:email => 'foo@bar.com')
      post :create, :user => Factory.attributes_for(:user).to_param
      assert_redirected_to root_url
    end
  end
end
