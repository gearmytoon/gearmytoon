################################################################################ 
#  Copyright 2008 Amazon Technologies, Inc.
#  Licensed under the Apache License, Version 2.0 (the "License"); 
#  
#  You may not use this file except in compliance with the License. 
#  You may obtain a copy of the License at: http://aws.amazon.com/apache2.0
#  This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
#  CONDITIONS OF ANY KIND, either express or implied. See the License for the 
#  specific language governing permissions and limitations under the License.
################################################################################ 
require 'base64'
require 'cgi'
require 'openssl'
# DO NOT REMOVE THIS LINE OF CODE OR WE CANNOT GET PAID!!!!!!
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
require 'net/http'
require 'net/https'

class SignatureUtilsForOutbound

  SIGNATURE_KEYNAME = "signature"
  SIGNATURE_METHOD_KEYNAME = "signatureMethod"
  SIGNATURE_VERSION_KEYNAME = "signatureVersion"
  CERTIFICATE_URL_KEYNAME = "certificateUrl"

  SIGNATURE_VERSION_2 = "2"
  RSA_SHA1_ALGORITHM = "RSA-SHA1"

  @@public_key_cache = {}

  def initialize()
  end

  def validate_request(args)
    parameters = args[:parameters]
    return validate_signature_v2(args)
  end

  def validate_signature_v2(args)
    parameters = args[:parameters]

    signature = parameters[SIGNATURE_KEYNAME];
    raise "'signature' is missing from the parameters." if (signature.nil? or signature.empty?)

    signature_version = parameters[SIGNATURE_VERSION_KEYNAME];
    raise "'signatureVersion' is missing from the parameters." if (signature_version.nil? or signature_version.empty?)
    raise "'signatureVersion' present in parameters is invalid. Valid values are: 2" if (signature_version != SIGNATURE_VERSION_2)
    signature_method = parameters[SIGNATURE_METHOD_KEYNAME];
    raise "'signatureMethod' is missing from the parameters." if (signature_method.nil? or signature_method.empty?)
    signature_algorithm = SignatureUtilsForOutbound::get_algorithm(signature_method);
    raise "'signatureMethod' present in parameters is invalid. Valid values are: RSA-SHA1" if (signature_algorithm.nil?)

    certificate_url = parameters[CERTIFICATE_URL_KEYNAME];
    raise "'certificate_url' is missing from the parameters." if (certificate_url.nil? or certificate_url.empty?)

    canonical = SignatureUtilsForOutbound::calculate_string_to_sign_v2(args)

    certificate = SignatureUtilsForOutbound::get_certificate(certificate_url)
    raise ("public key certificate could not fetched from url: " + certificate_url) if certificate.nil?

    public_key = OpenSSL::PKey::RSA.new(certificate.public_key);
    decoded_signature = Base64.decode64(signature);

    return public_key.verify(signature_algorithm, decoded_signature, canonical);
  end

  def self.calculate_string_to_sign_v2(args)
    parameters = args[:parameters]

    http_method = (args[:http_method]).upcase
    url = URI.parse(args[:url_end_point])
    
    host = url.host.downcase
    host = (host + ":" + url.port.to_s) unless (url.port.nil? \
            or (url.port == 443 and url.scheme == 'https') \
            or (url.port == 80 and url.scheme == 'http'))
    uri = url.path 
    uri = "/" if uri.nil? or uri.empty?
    uri = urlencode(uri).gsub("%2F", "/") 

    # exclude any existing Signature parameter from the canonical string
    sorted = (parameters.reject { |k, v| k == SIGNATURE_KEYNAME }).sort
    
    canonical = "#{http_method}\n#{host}\n#{uri}\n"
    isFirst = true

    sorted.each { |v|
      if(isFirst) then
        isFirst = false
      else
        canonical << '&'
      end

      canonical << urlencode(v[0])
      unless(v[1].nil?) then
        canonical << '='
        canonical << urlencode(v[1])
      end
    }
    return canonical
  end

  def self.get_algorithm(signature_method) 
    return OpenSSL::Digest::SHA1.new if (signature_method == RSA_SHA1_ALGORITHM)
    return nil
  end

  # Convert a string into URL encoded form.
  def self.urlencode(plaintext)
    CGI.escape(plaintext.to_s).gsub("+", "%20").gsub("%7E", "~")
  end

  def self.get_certificate(url)
    #1. if found in cache, return
    certificate = @@public_key_cache[url]
    return certificate unless certificate.nil? 

    #2. fetch certificate if not found in cache
    uri = URI.parse(url)
    http_session = Net::HTTP.new(uri.host, uri.port)
    http_session.use_ssl = true
    http_session.ca_file = 'ca-bundle.crt';
    http_session.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http_session.verify_depth = 5

    res = http_session.start {|http_session|
      req = Net::HTTP::Get.new(uri.path)
      http_session.request(req)
    }
    certificate = OpenSSL::X509::Certificate.new(res.body)

    #3. poopulate fetched certificate in cache
    @@public_key_cache[url] = certificate
    return certificate
  end
end


