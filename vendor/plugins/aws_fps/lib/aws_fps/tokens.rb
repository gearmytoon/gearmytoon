# Amazon FPS Plugin
module AWS_FPS

  class Tokens
    def self.get_caller_token
      unique_id = (Time.now.to_i + rand(1000)).to_s
      call = { 'Action' => 'InstallPaymentInstruction',
               'PaymentInstruction' => "MyRole == 'Caller' orSay 'Role does not match';",
               'CallerReference' => unique_id,
               'TokenType' => 'Unrestricted' }

      # Make the FPS call
  		@fps_response = AWS_FPS::Query.do(call)
  		response_xml = REXML::Document.new(@fps_response)
  		elements = response_xml.root.elements

  		unless elements["Status"].nil?
  		  @status = elements["Status"].text
    		return elements["TokenId"].text if @status == "Success"
    	end
    end

    def self.get_recipient_token
      unique_id = (Time.now.to_i + rand(1000)).to_s
      call = {'Action' => 'InstallPaymentInstruction',
        			'PaymentInstruction' => "MyRole == 'Recipient' orSay 'Roles do not match';",
        			'CallerReference' => unique_id,
        			'TokenType' => 'Unrestricted' }

      # Make the FPS call        
  		@fps_response = AWS_FPS::Query.do(call)
  		response_xml = REXML::Document.new(@fps_response)
  		elements = response_xml.root.elements

      # Return the recipient token
  		unless elements["Status"].nil?
  		  @status = elements["Status"].text
    		return elements["TokenId"].text if @status == "Success"
    	end
    end

  end

end