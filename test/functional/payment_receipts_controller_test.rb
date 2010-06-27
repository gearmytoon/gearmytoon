require File.dirname(__FILE__) + '/../test_helper'

class PaymentReceiptsControllerTest < ActionController::TestCase
  context "get show" do
    should "require login" do
      get :show
      assert_redirected_to new_user_session_path
    end

    should "only show a users payment receipts" do
      activate_authlogic
      @user = Factory(:user)
      2.times {Factory(:paid_payment, :purchaser => @user)}
      Factory(:paid_payment)
      get :show
      assert_response :success
      assert_select ".payment_receipt", :count => 2
    end

    should "show payment receipt details" do
      activate_authlogic
      @user = Factory(:user)
      frozen_time = freeze_time
      payment = Factory(:paid_payment, :purchaser => @user)
      get :show
      assert_response :success
      assert_select ".payment_receipt .plan", :text => "Personal"
      assert_select ".payment_receipt .amount", :text => "$3"
      assert_select ".payment_receipt .paid_at", :text => frozen_time.to_date.to_s(:long)
    end

  end
end
