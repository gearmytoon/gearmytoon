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
      assert_select ".payment_plan", :count => 2
    end
  end
  
  context "get reciept" do
    setup do
      activate_authlogic
      @user = Factory(:user)
    end

    should "create a payment model for the current user" do
      assert_difference "@user.reload.payments.count" do
        assert_difference "Payment.count" do
          get :receipt, "transactionId" => "abcd134"
        end
      end
    end

    should "assign transaction id for our model and put all data into raw_data" do
      get :receipt, "transactionId" => "abcd134", "wtf" => "bbq"
      new_payment = Payment.find_by_transaction_id("abcd134")
      assert_not_nil new_payment
      assert_equal({"transactionId" => "abcd134", "wtf" => "bbq"}, new_payment.raw_data)
    end

    should "show a user their reciept if payment was successful" do
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(true)
      get :receipt, "transactionId" => "abcd134"
      assert_response :success
      assert_select "#receipt .price", :text => "$3"
      assert_select "#receipt .email", :text => @user.email
      assert_select "#receipt .number_of_toons", :text => "5"
      assert_select "#receipt .plan", :text => "Personal"
    end

    should "mark a payment as paid if the payment was successful" do
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(true)
      frozen_time = freeze_time
      get :receipt, "transactionId" => "abcd134"
      assert_response :success
      new_payment = Payment.find_by_transaction_id("abcd134")
      assert new_payment.paid?
      assert_equal frozen_time.to_i, new_payment.paid_at.to_i
    end
    
    should "not mark a payment as paid if the payment wasn't successful" do
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(false)
      get :receipt, "transactionId" => "abcd134"
      assert_response :success
      assert_template "sorry"
      new_payment = Payment.find_by_transaction_id("abcd134")
      assert_false new_payment.reload.paid?
      assert new_payment.failed?
    end

    should "not call SignatureUtilsForOutbound again if the payment is failed" do
      payment = Factory(:failed_payment, :transaction_id => "12345", :purchaser => @user)
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).raises("WTF")
      assert_no_difference "Payment.count" do
        get :receipt, "transactionId" => "12345"
      end
      assert_response :success
      assert_template "sorry"
      assert payment.reload.failed?
    end

    should "not call SignatureUtilsForOutbound if the payment is successful" do
      payment = Factory(:paid_payment, :transaction_id => "12345", :purchaser => @user)
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).raises("WTF")
      assert_no_difference "Payment.count" do
        get :receipt, "transactionId" => "12345"
      end
      assert_response :success
      assert payment.reload.paid?
    end
    
  end
end
