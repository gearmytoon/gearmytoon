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

  context "post notify_payment" do
    should "infer user from referenceId" do
      user = Factory(:user)
      assert_difference "user.reload.payments.count" do
        post :notify_payment, "transactionId" => '123', "referenceId" => "#{user.id}-some_timestamp", "status" => "SS"
      end
      assert_equal "123", user.payments.first.transaction_id
    end

    should "create paid payments" do
      user = Factory(:user)
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(true)
      post :notify_payment, "transactionId" => '123', "referenceId" => "#{user.id}-some_timestamp", "status" => "SS"
      assert Payment.find_by_transaction_id('123').paid?
    end

    should "create failed payments" do
      user = Factory(:user)
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(false)
      post :notify_payment, "transactionId" => '123', "referenceId" => "#{user.id}-some_timestamp", "status" => "SS"
      new_payment = Payment.find_by_transaction_id('123')
      assert_false new_payment.paid?
      assert new_payment.failed?
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
          get :receipt, "transactionId" => "abcd134", "status" => "SS"
        end
      end
    end

    should "assign transaction id for our model and put all data into raw_data" do
      get :receipt, "transactionId" => "abcd134", "wtf" => "bbq", "status" => "SS"
      new_payment = Payment.find_by_transaction_id("abcd134")
      assert_not_nil new_payment
      assert_equal({"transactionId" => "abcd134", "wtf" => "bbq", "status" => "SS"}, new_payment.raw_data)
    end

    should "show a user their reciept if payment was successful" do
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(true)
      get :receipt, "transactionId" => "abcd134", "status" => "SS"
      assert_response :success
      assert_select "#receipt .price", :text => "$3"
      assert_select "#receipt .email", :text => @user.email
      assert_select "#receipt .number_of_toons", :text => "5"
      assert_select "#receipt .plan", :text => "Personal"
    end

    should "mark a payment as paid if the payment was successful" do
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(true)
      frozen_time = freeze_time
      get :receipt, "transactionId" => "abcd134", "status" => "SS"
      assert_response :success
      new_payment = Payment.find_by_transaction_id("abcd134")
      assert new_payment.paid?
      assert_equal frozen_time.to_i, new_payment.paid_at.to_i
    end
    
    should "not mark a payment as paid if request is not valid" do
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(false)
      get :receipt, "transactionId" => "abcd134", "status" => "SS"
      assert_response :success
      assert_template "sorry"
      new_payment = Payment.find_by_transaction_id("abcd134")
      assert_false new_payment.reload.paid?
      assert new_payment.failed?
    end
    
    should "make a payment paid if a valid status returned from amazon" do
      valid_status_codes = ["PS", "SS", "US", "SI", "PI", "PR"]
      valid_status_codes.each_with_index do |valid_status_code, index|
        SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(true)
        transaction_id = "#{index}-foo"
        get :receipt, "transactionId" => transaction_id, "status" => valid_status_code
        assert_response :success
        assert Payment.find_by_transaction_id(transaction_id).paid?
      end
    end

    should "make a payment failed if a invalid status returned from amazon" do
      invalid_status_codes = ["A", "ME", "PF", "SE", "SF"]
      invalid_status_codes.each_with_index do |invalid_status_code, index|
        SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(true)
        transaction_id = "#{index}-foo"
        get :receipt, "transactionId" => transaction_id, "status" => invalid_status_code
        assert_response :success
        assert Payment.find_by_transaction_id(transaction_id).failed?
      end
    end

    should "not call SignatureUtilsForOutbound again if the payment is failed" do
      payment = Factory(:failed_payment, :transaction_id => "12345", :purchaser => @user)
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).raises("WTF")
      assert_no_difference "Payment.count" do
        get :receipt, "transactionId" => "12345", "status" => "SS"
      end
      assert_response :success
      assert_template "sorry"
      assert payment.reload.failed?
    end

    should "not call SignatureUtilsForOutbound if the payment is successful" do
      payment = Factory(:paid_payment, :transaction_id => "12345", :purchaser => @user)
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).raises("WTF")
      assert_no_difference "Payment.count" do
        get :receipt, "transactionId" => "12345", "status" => "SS"
      end
      assert_response :success
      assert payment.reload.paid?
    end
    
  end
end
