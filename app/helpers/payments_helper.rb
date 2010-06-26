module PaymentsHelper
  
  def subscription_simple_pay_form
    #TODO if not test env:: ADD "ipnUrl"=>notify_payment_payment_url, 
    params = basic_params("recurringFrequency" => "1 month", "description" => "Gear My Toon Subscription", "amount" => "USD 3")
    content_tag :form, :action => "https://#{params[:host]}#{params[:uri]}", :method => params[:verb] do
      fields = params[:parameters].map{ |key, value| hidden_field_tag(key, value)}
      fields << hidden_field_tag('signature', SignatureUtils.sign_parameters(params))
      fields << "<input type=\"image\" src=\"http://g-ecx.images-amazon.com/images/G/01/asp/beige_small_subscribe_withlogo_darkbg.gif\" border=\"0\" />"
      fields
    end
  end
  
  def standard_simple_pay_form
    params = basic_params("isDonationWidget" => "0", "description" => "Gear My Toon Trial Account", "amount"=> "USD 1")
    content_tag :form, :action => "https://#{params[:host]}#{params[:uri]}", :method => params[:verb] do
      fields = params[:parameters].map{ |key, value| hidden_field_tag(key, value)}
      fields << hidden_field_tag('signature', SignatureUtils.sign_parameters(params))
      fields << "<input type=\"image\" src=\"http://g-ecx.images-amazon.com/images/G/01/asp/beige_small_paynow_withlogo_darkbg.gif\" border=\"0\"/>"
      fields
    end
  end
  
  def basic_params(payment_params)
    #TODO if not test env:: ADD "ipnUrl"=>notify_payment_payment_url, 
    params = {:host=>"authorize.payments-sandbox.amazon.com", :verb=>"POST", :algorithm=>"HmacSHA1", 
      :uri=>"/pba/paypipeline", 
      :parameters=>{"returnUrl"=>receipt_payment_url, "collectShippingAddress" => "0", 
        "cobrandingStyle"=>"logo", "signatureVersion"=>"2", "abandonUrl"=>payment_url, "immediateReturn"=>"1", 
        "accessKey"=>"AKIAJDSU5CTXKVEMH6OA", "processImmediate"=>"1", "signatureMethod"=>"HmacSHA1"}.merge(payment_params), 
      :aws_secret_key=>"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"}
  end
end
