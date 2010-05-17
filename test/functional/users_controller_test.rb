require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  context "get #show" do
    should "show how much longer a users account is active for" do
      activate_authlogic
      freeze_time
      user = Factory(:user)
      payment = Factory(:paid_payment, :purchaser => user)
      payment.update_attribute(:paid_at, 1.month.ago + 7.days)
      get :show
      assert_select "#days_until_billing", :text => "7 days"
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
