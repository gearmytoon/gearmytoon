# Amazon FPS Plugin
module AWS_FPS

  class Query
    class << self
      include AWS_FPS::Signature
      # Accepts Amazon FPS parameters. Returns false if HTTP error received.  
      # Otherwise, returns XML service response.
      def do(params)
        query = build_query(params)
        xml_response = send_query(query)
        return xml_response
      end

      def build_query(params)
        defaults =  { 'AWSAccessKeyId' => ACCESS_KEY, 
                      'SignatureVersion' => SIGNATURE_VERSION,
                      'Version' => VERSION,
                      'Timestamp' => Time.now.gmtime.iso8601 }
        params = params.merge defaults

        # Sort params by Hash key, returns Array
        params = fps_sort(params)

        # Create digest of concatenated params
        signature = fps_sign(params.to_s)

        # URL-encode and join params with "&" and "=" to form full request
        query = '/?' + fps_urlencode(params).to_s + "&Signature=" + CGI.escape(signature)
      end

      # Queries Amazon FPS service and returns XML service response
      def send_query(query)
        url = ENDPOINT + query

        # Send Amazon FPS query to endpoint
        url = URI.parse(url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        req = Net::HTTP::Get.new(query)
        response = http.start { |http| http.request(req) }

        xml_response = response.body.to_s
        xml_response.gsub! "ns3:", ""
        xml_response.gsub! "ns2:", ""

        # 200s and 401s HTTP responses return XML
        case response
          when Net::HTTPSuccess then 
            return xml_response
          when Net::HTTPUnauthorized then
            return xml_response
          when Net::HTTPInternalServerError then
            return xml_response
          when Net::HTTPBadRequest then
            return xml_response
          else
            false
        end
      end
    end
  end # Query class

end