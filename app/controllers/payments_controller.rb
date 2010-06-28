class PaymentsController < ApplicationController
  before_filter :require_user, :except => [:notify_payment]
  protect_from_forgery :except => :notify_payment
  DOMAIN_NAMES = {"development" => "localhost:3000", "production" =>  "gearmytoon.com", "test" => "localhost:3000"}
  def show
    @current_user = current_user
  end

  # amazon post to URL
  def notify_payment
    user = User.find(params['referenceId'].split("-").first)
    check_payment("POST", user)
    render :text => "Thank you!"
  end

  # Users redirect to URL
  def receipt
    check_payment("GET", current_user)
    if @payment.failed?
      flash.now[:error] = "We are sorry, we were not able to verify your payment from Amazon.com"
      render "sorry"
    end
  end

  private
  
  def check_payment(http_method, user)
    begin
      payment_params = params.except(:controller, :action)
      @payment = user.payments.find_by_transaction_id(payment_params["transactionId"])
      return nil if @payment
      @payment = user.payments.create!(:raw_data => payment_params, :transaction_id => payment_params["transactionId"])
      url_end_point = ("http://" + DOMAIN_NAMES[RAILS_ENV] + request.request_uri).split('?').first
      @payment.validate_payment(url_end_point, http_method)
    rescue Exception => ex
      logger.error "a problem occured when processing a payment: #{ex.message} \n #{ex.backtrace}"
      @payment.fail!
    end
  end

end
