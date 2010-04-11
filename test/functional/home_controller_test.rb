require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase
  context "get index" do
    should "respond with success" do
      get :index
      assert_response :success
    end
  end

  context "interested" do
    context "get" do
      setup { get :interested }

      should_render_template :interested
      should_respond_with :success
      should_assign_to :beta_participant
    end

    context "post" do
      should "create a beta participant" do
        post :interested, :beta_participant => { :email => 'foo@bar.com' }
        assert_equal 'Thanks for your interest!', flash[:notice]
        assert_redirected_to root_url
      end

      should "not create a beta participant" do
        post :interested, :beta_participant => { :email => '' }
        assert !assigns(:beta_participant).valid?
        assert_template :interested
      end
    end
  end
end
