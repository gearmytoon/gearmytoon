require File.dirname(__FILE__) + '/../test_helper'

class PaymentsControllerTest < ActionController::TestCase
  context "get show" do
    setup do
      activate_authlogic
      @user = Factory(:user)
    end
    should "respond with success" do
      get :show
      assert_select "#new_payment"
      assert_select "#payment_recipient_token", :count => 1 do |elements|
        element = elements.first
        assert element.attributes['value'].present?
      end
      assert_response :success
    end
  end
  
  context "post create" do
    setup do
      activate_authlogic
      @user = Factory(:user)
    end
    should "create a payment model" do
      recipient_token = AWS_FPS::Tokens.get_recipient_token
      caller_token = AWS_FPS::Tokens.get_caller_token
      assert_difference "@user.reload.payments.count" do
        assert_difference "Payment.count" do
          post :create, :payment => {:recipient_token => recipient_token, :caller_token => caller_token}
        end
      end
      new_payment = Payment.last
      assert_equal recipient_token, new_payment.recipient_token
      assert_not_nil new_payment.caller_reference
    end
    
    should "redirect to amazon" do
      recipient_token = AWS_FPS::Tokens.get_recipient_token
      caller_token = AWS_FPS::Tokens.get_caller_token
      post :create, :payment => {:recipient_token => recipient_token, :caller_token => caller_token}
      assert_response :redirect
      assert @response.header['Location'].starts_with?("https://authorize.payments-sandbox.amazon.com/cobranded-ui/actions/start?")
    end
    
    should "protect against mass assignment attacks" do
      recipient_token = AWS_FPS::Tokens.get_recipient_token
      caller_token = AWS_FPS::Tokens.get_caller_token
      post :create, :payment => {:recipient_token => recipient_token, :caller_token => caller_token}
      assert_response :redirect
      assert_not_equal "paid", Payment.last.status
    end
  
    should "move to the considering payment state" do
      recipient_token = AWS_FPS::Tokens.get_recipient_token
      caller_token = AWS_FPS::Tokens.get_caller_token
      post :create, :payment => {:recipient_token => recipient_token, :caller_token => caller_token}
      assert_response :redirect
      assert_equal "considering_payment", Payment.last.status
    end
    
    should "get assigned to login user" do
      recipient_token = AWS_FPS::Tokens.get_recipient_token
      caller_token = AWS_FPS::Tokens.get_caller_token
      post :create, :payment => {:recipient_token => recipient_token, :caller_token => caller_token}
      assert_response :redirect
      assert_equal @user, Payment.last.purchaser
    end
  end
  
  context "get reciept" do
    setup do
      activate_authlogic
      @user = Factory(:user)
    end
    
    should "show a user their reciept if payment was successful" do
      payment = Factory(:considering_payment, :purchaser => @user)
      @controller.stubs(:fps_success?).returns(true)
      get :receipt, :callerReference => payment.caller_reference
      assert_response :success
      assert_select "#receipt .price", :text => "$5"
      assert_select "#receipt .email", :text => @user.email
      assert_select "#receipt .number_of_toons", :text => "5"
      assert_select "#receipt .plan", :text => "Personal"
    end

    should "mark a payment as paid if the payment was successful" do
      payment = Factory(:considering_payment)
      @controller.stubs(:fps_success?).returns(true)
      get :receipt, :callerReference => payment.caller_reference
      assert_response :success
      assert Payment.last.paid?
    end
    
    should "not mark a payment as paid if the payment wasn't successful" do
      payment = Factory(:considering_payment)
      @controller.stubs(:fps_success?).returns(false)
      get :receipt, :callerReference => payment.caller_reference
      assert_response :success
      assert_template "sorry"
      assert_false Payment.last.paid?
      assert Payment.last.failed?
    end

    should "not call fps success again if the payment is failed" do
      payment = Factory(:failed_payment)
      @controller.stubs(:fps_success?).raises("WTF")
      get :receipt, :callerReference => payment.caller_reference
      assert_response :success
      assert_template "sorry"
      assert Payment.last.failed?
    end

    should "not call fps success again if the payment is successful" do
      payment = Factory(:paid_payment)
      @controller.stubs(:fps_success?).raises("WTF")
      get :receipt, :callerReference => payment.caller_reference
      assert_response :success
      assert Payment.last.paid?
    end
    
  end
end
