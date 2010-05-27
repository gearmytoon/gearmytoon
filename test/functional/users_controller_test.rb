require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  context "post create" do
    should "not be able to mass assign free access or admin" do
      activate_authlogic
      email = "#{Time.now.to_i}@foo.com"
      assert_difference "User.count" do
        post :create, :user => {:email => email, :password => "hello_world", :password_confirmation => "hello_world", :free_access => "true", :admin => "true"}
      end
      new_user = User.find_by_email(email)
      assert_false new_user.admin
      assert_false new_user.free_access
    end
  end
  
  context "get #show" do
    should "not display characters unless they are found" do
      activate_authlogic
      freeze_time
      user = Factory(:user)
      Factory(:user_character, :subscriber => user)
      Factory(:user_character, :subscriber => user, :character => Factory(:new_character, :name => "foo")).character.unable_to_load!
      Factory(:user_character, :subscriber => user, :character => Factory(:new_character, :name => "bar"))
      get :show
      assert_select ".character", :count => 1
    end

    should "show how much longer a users account is active for" do
      activate_authlogic
      freeze_time
      user = Factory(:user)
      payment = Factory(:paid_payment, :purchaser => user)
      payment.update_attribute(:paid_at, 1.month.ago + 1.day)
      get :show
      assert_select "#days_until_billing", :text => "1 day"
      assert_select "#current_payment_plan", :text => "5 toons"
    end

    should "not show expired payment plans" do
      activate_authlogic
      user = Factory(:user)
      payment = Factory(:paid_payment, :purchaser => user)
      payment.update_attribute(:paid_at, 45.days.ago)
      get :show
      assert_select "#days_until_billing", :count => 0
      assert_select "#current_payment_plan", :text => "None"
    end

    should "show no payment plan if you haven't paid before" do
      activate_authlogic
      user = Factory(:user)
      get :show
      assert_select "#current_payment_plan", :text => "None"
    end

  end
end
