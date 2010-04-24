class PaymentsController < ApplicationController
  before_filter :require_user

  def show
    @payment = Payment.new(:recipient_token => get_recipient_token)
  end
  
  def create
    @payment = current_user.payments.create!(params[:payment].merge(:caller_reference => Time.now.to_i.to_s))
    recurring_use_pipeline = remit.get_recurring_use_pipeline(
      :caller_reference => @payment.caller_reference,
      :recipient_token => @payment.recipient_token,
      :transaction_amount => 5,
      :recurring_period => "1 Month",
      :return_url => reciept_payment_url,
      :caller_key => FPS_ACCESS_KEY
    )
    redirect_to recurring_use_pipeline.url # this is the URL you want to send your users to
  end
  
  def reciept
    pipeline_response = Remit::PipelineResponse.new(request.request_uri,FPS_SECRET_KEY)
    payment = Payment.find_by_caller_reference(params[:callerReference])
    payment.pay! if pipeline_response.successful?
    render :text => "hihi"
  end
  
  private
  def get_caller_token
    request = Remit::InstallPaymentInstruction::Request.new(
      :payment_instruction => "MyRole == 'Caller' orSay 'Role does not match';",
      :caller_reference => Time.now.to_i.to_s,
      :token_friendly_name => "GearMyToon Caller Token",
      :token_type => "Unrestricted"
    )
    install_caller_response = remit.install_payment_instruction(request)
    install_caller_response.token_id  # hold on to this
  end
  
  def get_recipient_token
    request = Remit::InstallPaymentInstruction::Request.new(
      :payment_instruction => "MyRole == 'Recipient' orSay 'Role does not match';",
      :caller_reference => Time.now.to_i.to_s,
      :token_friendly_name => "GearMyToon Recipient Token",
      :token_type => "Unrestricted"
    )
    install_recipient_response = remit.install_payment_instruction(request)
    install_recipient_response.token_id  # hold on to this
  end
  
  def remit
    @remit ||= begin
      sandbox = !Rails.env.production?
      Remit::API.new(FPS_ACCESS_KEY, FPS_SECRET_KEY, sandbox)
    end
  end

end
