require 'test/test_helper'

class InvitesControllerTest < ActionController::TestCase
  context "post #create valid invitation" do
    setup do
      activate_authlogic
      user_session = UserSession.new(Factory(:admin))
      user_session.id = :admin
      user_session.save
      post :create, :invite => {:email => 'foo@bar.com'}
    end

    should "create a new invitation" do
      assert !assigns(:invite).new_record?
    end

    should "set the flash notice" do
      assert_equal "Invitation Sent!", flash[:notice]
    end

    should "redirect to the current_user's account page" do
      assert_redirected_to account_url
    end
  end

  context "post #create invalid invitation" do
    should "set the flash error" do
      activate_authlogic
      user_session = UserSession.new(Factory(:admin))
      user_session.id = :admin
      user_session.save
      post :create, :invite => {:email => nil}
      assert_equal "There was a problem sending the invitation.", flash[:error]
    end
  end
end
