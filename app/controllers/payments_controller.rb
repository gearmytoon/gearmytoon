class PaymentsController < ApplicationController
  before_filter :require_user

  def show
  end

  # amazon post to URL
  def notify_payment
    handle_payment("POST")
    render :text => "Thank you!"
  end

  # Users redirect to URL
  def receipt
    #check payment
    handle_payment("GET")
    if @payment.failed?
      flash.now[:error] = "We are sorry, we were not able to verify your payment from Amazon.com"
      render "sorry"
    end
  end

  private
  def handle_payment(http_method)
    begin
      @payment = current_user.payments.create!(:raw_data => params)
      signiture_correct = SignatureUtilsForOutbound.new.validate_request(:parameters => params, :url_end_point => @request.request_uri, :http_method => http_method)
      if signiture_correct
        @payment.pay!
      else
        @payment.fail!
      end
    rescue Exception => ex
      logger.error "a problem occured when processing a payment: #{ex.message} \n #{ex.backtrace}"
      @payment.fail!
    end
  end
  
end
