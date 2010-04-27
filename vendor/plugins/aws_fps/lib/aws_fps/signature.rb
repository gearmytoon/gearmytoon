# Amazon FPS Plugin
module AWS_FPS

  module Signature
    # Case-insensitive sort by Hash key
    def fps_sort(params)
      params.sort_by { |key,value| key.downcase }
    end
    
    # HMAC SHA1 sign a string
    def fps_sign(string)
      digest = OpenSSL::Digest::Digest.new('sha1')
      hmac = OpenSSL::HMAC.digest(digest, SECRET_ACCESS_KEY, string)
      Base64.encode64(hmac).chomp
    end

    # Params are URL-encoded, also add '=' and '&'
    def fps_urlencode(params)
      params.collect {|key, value| key+"="+CGI.escape(value)}.join("&")
    end

    def fps_join(params)
      params.collect {|key, value| key+"="+value}.join("&")
    end
  end
  
end