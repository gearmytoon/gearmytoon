class PaymentsController < ApplicationController
  before_filter :require_user

  def show
  end

  def create
    caller_reference = 'SenderToken-' + (Time.now.to_i + rand(1000)).to_s
    @payment = current_user.payments.create!(params[:payment].merge(:caller_reference => caller_reference))
    redirect_to(make_payment_url(@payment))
  end
  
  def receipt
    @payment = Payment.find_by_caller_reference(params[:callerReference])
    if @payment.considering_payment?
      if fps_success?
        @payment.pay!
      else
        @payment.fail!
      end
    end
    if @payment.failed?
      flash.now[:error] = "We are sorry, we were not able to verify your payment from Amazon.com"
      render "sorry"
    end
  end

end
