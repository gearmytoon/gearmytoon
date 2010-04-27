# Amazon FPS Plugin
module AWS_FPS

  class Pipeline
    class << self
      include AWS_FPS::Signature
      def make_url(pipeline_params, return_params, return_url)
        # Create URL-encoded return_url param
        return_url = return_url + "?" + fps_join(return_params)

        # Add already URL-encoded 'returnURL' and Amazon Web Services Access Key
        params = { 'returnURL' => return_url, 'callerKey' => ACCESS_KEY }.merge pipeline_params
        params = fps_sort(params)
        params = fps_urlencode(params)
      
        # Sign path and URL-encoded params
        sig_path = "/cobranded-ui/actions/start?" + params
        signature = fps_sign(sig_path)
        url =  PIPELINE + params + "&awsSignature=" + CGI.escape(signature)
        return url
      end
    end
  end

end