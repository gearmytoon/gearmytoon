class PaymentController < ApplicationController
  require 'rexml/document'

  def index
    @caller_token = AWS_FPS::Tokens.get_caller_token
    @recipient_token = AWS_FPS::Tokens.get_recipient_token
  end

  def amazon_pipeline
    return_path = "payment/pay"
    unique_id = (Time.now.to_i + rand(1000)).to_s

    # Prepare configuration for the Amazon Payments Pipeline
		pipeline_params = { 'transactionAmount' => params[:Amount],
    		                'pipelineName'      => 'Recurring',
      		              'paymentReason'     => 'Monthly Subscription',
      		              'recurringPeriod'   => '1 Month',
      		              'callerReference'   => 'SenderToken-' + unique_id }

    # Params for the return URL after the request is processed. 
    return_params = { 'Amount'           => params[:Amount],
                      'CallerTokenId'    => params[:CallerTokenId],
                      'RecipientTokenId' => params[:RecipientTokenId] }

    pipeline_url = AWS_FPS::Pipeline.make_url(pipeline_params, return_params, return_path)
    redirect_to(pipeline_url)
  end
  
  def pay
    # Prepare the FPS Payment Call
    unique_id = (Time.now.to_i + rand(1000)).to_s
    reference = "Monthly subscription."
    fps_call = AWS_FPS::Payment.prepare_call(params[:CallerTokenId], params[:tokenID], params[:RecipientTokenId], params[:Amount], unique_id, reference)

    # Make the payment call
		@fps_response = AWS_FPS::Query.do(fps_call)
		response_xml = REXML::Document.new(@fps_response)
		result = response_xml.root.elements

		@status = result["Status"].text
		@request_id = result["RequestId"].text
		@success = false

		if @status == "Success"
		  @success = true
		  @transaction_id = result["TransactionResponse"].elements['TransactionId'].text
		end

    redirect_to :controller => :payment, :action => :receipt, :id => @transaction_id
  end
  
  def receipt
    # Pull transaction data back from Amazon
    call = { 'Action' => 'GetTransaction', 'TransactionId' => params[:id] } 
		@transaction_data = AWS_FPS::Query.do(call)

    # Parse the response
		response = REXML::Document.new(@transaction_data)
		result = response.root.elements
		@status = result["Status"].text
		@request_id = result["RequestId"].text
		
    @status == "Success" ? @success = true : @success = false
  end
  
end