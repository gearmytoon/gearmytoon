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
    should "be able to go from unpaid payment to a paid payment" do
      user = Factory(:user)
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(false)
      assert_difference "user.reload.payments.count" do
        post :notify_payment, "buyerName"=>"Nolan L Evans", "paymentReason"=>"Gear My Toon Subscription", "signatureVersion"=>"2", "transactionDate"=>"1277706718", "action"=>"notify_payment", "transactionAmount"=>"USD 3.00", "signature"=>"xpcwXOxkYZf+V7FpwnsUValQe7WL16iv8A+VxpQaVV4VKG0zRDVbYMhsnTfkmdL7jn2Kx5UCxlOu\nervi2aTIAOVWjutdCzTKDwImx/2TBteqLvbY4Ks4JqPvI/+NbdQ+VZjzrbsvPRaFj26oOTXzSwzm\nYt6yMSY1ns+viAiOXuZ74dsO3LfQu9bl5Vdu1KiBfotlCHNmDqMfu/ZVgE5gDFyibKfcxhd10sjM\n5LmDb8N/pEt13KCPVlZCAeJeH13CteNmS1qfT2iJDzA0SqeZCM2ns/ZAVBT4qlX2rhiPtkTWVR1Q\nGWPRcHMpw0MoxE+IQruEF96cEaTFotxIuIsCjA==", "subscriptionId"=>"ef2bb4d0-5916-4d3a-8789-1cf0c128ea24", "recipientName"=>"GearMyToon", "certificateUrl"=>"https://fps.amazonaws.com/certs/090909/PKICert.pem", "transactionId"=>"155UK2J9LK8JJGLKEEDTNVM7D1DUNCVRANK", "signatureMethod"=>"RSA-SHA1", "recipientEmail"=>"gearmytoon@gmail.com", "transactionSerialNumber"=>"1", "controller"=>"payments", "referenceId"=>"#{user.id}-1277706695", "status"=>"PI", "buyerEmail"=>"nolane@gmail.com", "operation"=>"pay", "paymentMethod"=>"CC"
      end
      assert_equal "155UK2J9LK8JJGLKEEDTNVM7D1DUNCVRANK", user.reload.payments.last.transaction_id
      assert_equal "failed", user.reload.payments.last.status
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(true)
      assert_no_difference "user.reload.payments.count" do
        post :notify_payment, "recurringFrequency"=>"1 month", "buyerName"=>"Nolan L Evans", "paymentReason"=>"Gear My Toon Subscription", "signatureVersion"=>"2", "transactionDate"=>"1277706717", "action"=>"receipt", "transactionAmount"=>"USD 3", "signature"=>"kq73YRLowJioGDxLrPdzUn8Lks/AeDCEHlOvNvlWnFE8/n3j6VPpqdPzg+fi0HGXT8yNWb9VHf+q\nCJT2By2ys2/zO2h5mGIW8Zzwig1lJdXWNvGNWiGuzEBYt7qr3Nnp8cvqpJx7NVUB5pv24t/iXeBC\n2WK0bLSXKZtKpSz/gpC0VQoU/JxXwE7j+SG4zt5WHBMKG6NoberqdYOOKmjT/t1V5Bl1HCXyxV4p\ng+On4Wxi9eohXn0bFNEEHi40l4wlZtZVqQ5rD9F1Bsl6KBSi5FAGEdUJMMpGdcp6dkLsWzZM0ve5\nnUalz0WMX8+aAC7RrkVWg0AA80GCv4/l8Iu9pA==", "subscriptionId"=>"ef2bb4d0-5916-4d3a-8789-1cf0c128ea24", "recipientName"=>"GearMyToon", "certificateUrl"=>"https://fps.amazonaws.com/certs/090909/PKICert.pem", "transactionId"=>"155UK2J9LK8JJGLKEEDTNVM7D1DUNCVRANK", "signatureMethod"=>"RSA-SHA1", "recipientEmail"=>"gearmytoon@gmail.com", "transactionSerialNumber"=>"1", "controller"=>"payments", "referenceId"=>"#{user.id}-1277706695", "status"=>"SS", "buyerEmail"=>"nolane@gmail.com", "operation"=>"pay", "paymentMethod"=>"Credit Card"
      end
      assert_equal "paid", user.reload.payments.last.status
      assert_equal "SS", user.reload.payments.last.raw_data['status']
      assert user.reload.payments.last.recurring?
    end
    
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

    should "know if the payment is a recurring plan" do
      get :receipt, "transactionId" => "abcd134", "status" => "SS", "subscriptionId" => "1234"
      new_payment = Payment.find_by_transaction_id("abcd134")
      assert_equal Payment::RECURRING, new_payment.plan_type
    end

    should "set the expiry date to a month from now if recurring" do
      get :receipt, "transactionId" => "abcd134", "status" => "SS", "recurringFrequency" => "1 month"
      new_payment = Payment.find_by_transaction_id("abcd134")
      assert_equal Payment::RECURRING, new_payment.plan_type
    end

    should "set the expiry date to a month from now if recurring" do
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(true)
      freeze_time
      get :receipt, "transactionId" => "abcd134", "status" => "SS", "subscriptionId" => "1234"
      new_payment = Payment.find_by_transaction_id("abcd134")
      assert new_payment.paid?
      assert_equal (1.month + 5.days).from_now.to_i, new_payment.paid_until.to_i
    end

    should "set the expiry date to a day from now if not recurring" do
      SignatureUtilsForOutbound.any_instance.expects(:validate_request).returns(true)
      freeze_time
      get :receipt, "transactionId" => "abcd134", "status" => "SS"
      new_payment = Payment.find_by_transaction_id("abcd134")
      assert new_payment.paid?
      assert_equal (1.day + 5.hours).from_now.to_i, new_payment.paid_until.to_i
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
      get :receipt, "transactionId" => "abcd134", "status" => "SS"
      assert_response :success
      new_payment = Payment.find_by_transaction_id("abcd134")
      assert new_payment.paid?
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
