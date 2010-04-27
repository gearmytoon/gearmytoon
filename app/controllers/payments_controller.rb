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
    unique_id = (Time.now.to_i + rand(1000)).to_s
    
    if fps_success?
      @payment = Payment.find_by_caller_reference(params[:callerReference])
      @payment.pay!
    else
      flash.now[:error] = "We are sorry, we were not able to verify your payment from Amazon.com"
      render "sorry"
    end
  end

  protected
  
  def make_payment_url(payment)
    # Prepare configuration for the Amazon Payments Pipeline
    pipeline_params = { 'transactionAmount' => "5",
                        'pipelineName'      => 'Recurring',
                        'paymentReason'     => 'Monthly Subscription',
                        'recurringPeriod'   => '1 Month',
                        'callerReference'   => payment.caller_reference }

    # Params for the return URL after the request is processed.
    return_params = { 'Amount'           => "5",
                      'CallerTokenId'    => payment.caller_token,
                      'RecipientTokenId' => payment.recipient_token }
    
    AWS_FPS::Pipeline.make_url(pipeline_params, return_params, "payment/receipt")
  end
  def fps_success?
    fps_call = AWS_FPS::Payment.prepare_call(params[:CallerTokenId], params[:tokenID], params[:RecipientTokenId], params[:Amount], unique_id, "Monthly subscription.")
    # Make the payment call
    response_xml = REXML::Document.new(AWS_FPS::Query.do(fps_call))
    result = response_xml.root.elements
    # @request_id = result["RequestId"].text
    # @transaction_id = result["TransactionResponse"].elements['TransactionId'].text
    result["Status"].text == "Success"
  end
end

# class PaymentsController < ApplicationController
#   before_filter :require_user
#   
#   def create
#     @payment = current_user.payments.create!(params[:payment].merge(:caller_reference => Time.now.to_i.to_s))
#     recurring_use_pipeline = remit.get_recurring_use_pipeline(
#       :caller_reference => @payment.caller_reference,
#       :recipient_token => @payment.recipient_token,
#       :transaction_amount => 5,
#       :recurring_period => "1 Month",
#       :return_url => receipt_payment_url,
#       :caller_key => FPS_ACCESS_KEY
#     )
#     redirect_to recurring_use_pipeline.url # this is the URL you want to send your users to
#   end
#   
#   def receipt
#     pipeline_response = Remit::PipelineResponse.new(request.request_uri,FPS_SECRET_KEY)
#     @payment = Payment.find_by_caller_reference(params[:callerReference])
#     if pipeline_response.successful?
#       @payment.pay!
#     else
#       flash.now[:error] = "We are sorry, we were not able to verify your payment from Amazon.com"
#       render "sorry"
#     end
#   end
#   
#   private
#   def get_caller_token
#     request = Remit::InstallPaymentInstruction::Request.new(
#       :payment_instruction => "MyRole == 'Caller' orSay 'Role does not match';",
#       :caller_reference => Time.now.to_i.to_s,
#       :token_friendly_name => "GearMyToon Caller Token",
#       :token_type => "Unrestricted"
#     )
#     install_caller_response = remit.install_payment_instruction(request)
#     install_caller_response.token_id  # hold on to this
#   end
#   
#   def get_recipient_token
#     request = Remit::InstallPaymentInstruction::Request.new(
#       :payment_instruction => "MyRole == 'Recipient' orSay 'Role does not match';",
#       :caller_reference => Time.now.to_i.to_s,
#       :token_friendly_name => "GearMyToon Recipient Token",
#       :token_type => "Unrestricted"
#     )
#     install_recipient_response = remit.install_payment_instruction(request)
#     install_recipient_response.token_id  # hold on to this
#   end
#   
#   def remit
#     @remit ||= begin
#       sandbox = !Rails.env.production?
#       Remit::API.new(FPS_ACCESS_KEY, FPS_SECRET_KEY, sandbox)
#     end
#   end
# 
# end
