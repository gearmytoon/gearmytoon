class PaymentsController < ApplicationController
  require 'rexml/document'
  before_filter :require_user

  def show
    caller_token = AWS_FPS::Tokens.get_caller_token
    recipient_token = AWS_FPS::Tokens.get_recipient_token
    @payment = Payment.new(:recipient_token => recipient_token, :caller_token => caller_token)
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

  protected
  
  def make_payment_url(payment)
    begin
      # Prepare configuration for the Amazon Payments Pipeline
      pipeline_params = { 'transactionAmount' => "1",
                          'pipelineName'      => 'Recurring',
                          'paymentReason'     => 'Monthly Subscription',
                          'recurringPeriod'   => '1 Month',
                          'callerReference'   => payment.caller_reference }

      # Params for the return URL after the request is processed.
      return_params = { 'Amount'           => "1",
                        'CallerTokenId'    => payment.caller_token,
                        'RecipientTokenId' => payment.recipient_token }
      AWS_FPS::Pipeline.make_url(pipeline_params, return_params, receipt_payment_url)
    rescue Exception => ex
      p return_params
      p pipeline_params
      raise ex
    end
  end
  def fps_success?
    unique_id = UUID.new.generate
    fps_call = AWS_FPS::Payment.prepare_call(params[:CallerTokenId], params[:tokenID], params[:RecipientTokenId], params[:Amount], unique_id, "Monthly subscription.")
    # Make the payment call
    response_xml = REXML::Document.new(AWS_FPS::Query.do(fps_call))
    result = response_xml.root.elements
    # @request_id = result["RequestId"].text
    # @transaction_id = result["TransactionResponse"].elements['TransactionId'].text
    result["Status"].text == "Success"
  end
end
