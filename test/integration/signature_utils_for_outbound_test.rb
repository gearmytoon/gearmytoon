require File.dirname(__FILE__) + '/../test_helper'

class SignatureUtilsForOutboundTest < ActiveSupport::TestCase
  
  context "recurring payments" do
    should "validate a proper subscription request" do
      payment_params = {"status"=>"SS", "paymentMethod"=>"Credit Card", "buyerName"=>"Nolan L Evans", "recurringFrequency"=>"1 month", "signature"=>"Nq+L/x+oAoW1ltuF7uHnvbLpDOHzarwQ9tqm5jVnKc3/va13G8u8h0RENI56RaL834B901wRotV+UrgdyzqLqHnuMk6nmF7lmncxiMium3LaouuTPemX7Jpi38jSwRFEB4Sqt+olBrdzos2ZyCn8wQTQ/403bUTiJ4c4w6kyxK7KHuK8QQ478AaZvjPJDUi4926Dg9tfkjVcLVMP8luIihEkf0ZH4q2Qt3aRgQICqsxlcagZ+QrRr3sbv5qtToE1P+ivcZAFuUSu+RdUH1y7a2mpNdai6+rBOs+/Z17LE+ji7Cz0OfsBY4QBfc37kVV4G3LXZdXLhvyiL2meXNywyA==", "subscriptionId"=>"181748fb-41b0-46c1-a601-1c2e5955e80e", "transactionId"=>"155R3NQBJ6IT8O6MAT9BUP9G957BS9HH71V", "paymentReason"=>"Gear My Toon Subscription", "signatureVersion"=>"2", "transactionAmount"=>"USD 3", "recipientName"=>"Test Business", "transactionDate"=>"1277588924", "certificateUrl"=>"https://fps.sandbox.amazonaws.com/certs/090909/PKICert.pem", "signatureMethod"=>"RSA-SHA1", "operation"=>"pay", "recipientEmail"=>"gearmytoon@gmail.com", "transactionSerialNumber"=>"1", "buyerEmail"=>"nolane@gmail.com"}
      url_end_point = "http://localhost:3000/payment/receipt"
      assert SignatureUtilsForOutbound.new.validate_request(:parameters => payment_params, :url_end_point => url_end_point, :http_method => "GET")
    end

    should "not validate a invalid subscription request" do
      #missing 'N' from start of signature
      payment_params = {"status"=>"SS", "paymentMethod"=>"Credit Card", "buyerName"=>"Nolan L Evans", "recurringFrequency"=>"1 month", "signature"=>"q+L/x+oAoW1ltuF7uHnvbLpDOHzarwQ9tqm5jVnKc3/va13G8u8h0RENI56RaL834B901wRotV+UrgdyzqLqHnuMk6nmF7lmncxiMium3LaouuTPemX7Jpi38jSwRFEB4Sqt+olBrdzos2ZyCn8wQTQ/403bUTiJ4c4w6kyxK7KHuK8QQ478AaZvjPJDUi4926Dg9tfkjVcLVMP8luIihEkf0ZH4q2Qt3aRgQICqsxlcagZ+QrRr3sbv5qtToE1P+ivcZAFuUSu+RdUH1y7a2mpNdai6+rBOs+/Z17LE+ji7Cz0OfsBY4QBfc37kVV4G3LXZdXLhvyiL2meXNywyA==", "subscriptionId"=>"181748fb-41b0-46c1-a601-1c2e5955e80e", "transactionId"=>"155R3NQBJ6IT8O6MAT9BUP9G957BS9HH71V", "paymentReason"=>"Gear My Toon Subscription", "signatureVersion"=>"2", "transactionAmount"=>"USD 3", "recipientName"=>"Test Business", "transactionDate"=>"1277588924", "certificateUrl"=>"https://fps.sandbox.amazonaws.com/certs/090909/PKICert.pem", "signatureMethod"=>"RSA-SHA1", "operation"=>"pay", "recipientEmail"=>"gearmytoon@gmail.com", "transactionSerialNumber"=>"1", "buyerEmail"=>"nolane@gmail.com"}
      url_end_point = "http://localhost:3000/payment/receipt"
      assert_false SignatureUtilsForOutbound.new.validate_request(:parameters => payment_params, :url_end_point => url_end_point, :http_method => "GET")
    end
  end

  #one time
  context "one time payments" do
    should "validate a proper standard payment request" do
      payment_params = {"status"=>"PS", "paymentMethod"=>"Credit Card", "buyerName"=>"Nolan L Evans", "signature"=>"u+z6x+1Ms+XMmO/HaoVqfPX0s2XlBePciU5ocyZYsdxcpqWTJWWSN+CuqMi2x3yxpakuL97LtCBiwt4DFTW5lIrgHlWzQKeW288tLGzu3ZWAV3hLfzCKmJKcAgrpmylQHhf1WbREgE2dU7f/KPlnZ+hi9kxAGgubm0AuIAb2GQEOfALA59FI1s7eJCP9WBKqzrSy8BHdgooWFbCCm49xwcPtwQ0UcV1qH3ff9Y0s5N7A+cdU7CN2UquAazSerbMxv9286cUbFjA3viNTgj6fTpPrdfyC5xMk+mRcuAI6aWax263VHvneNnqsLKWxfW7lKpqfIyQts167a3/9p7IjZQ==", "transactionId"=>"21277589Z541Z28C6J368HQQ4G8F38FG8I6", "paymentReason"=>"Gear My Toon Trial Account", "signatureVersion"=>"2", "transactionAmount"=>"USD 1", "recipientName"=>"Test Business", "transactionDate"=>"1277589054", "certificateUrl"=>"https://fps.sandbox.amazonaws.com/certs/090909/PKICert.pem", "signatureMethod"=>"RSA-SHA1", "operation"=>"pay", "recipientEmail"=>"gearmytoon@gmail.com", "buyerEmail"=>"nolane@gmail.com"}
      url_end_point = "http://localhost:3000/payment/receipt"
      assert SignatureUtilsForOutbound.new.validate_request(:parameters => payment_params, :url_end_point => url_end_point, :http_method => "GET")
    end

    should "not validate a invalid standard payment request" do
      #missing 'u' from start of signature
      payment_params = {"status"=>"PS", "paymentMethod"=>"Credit Card", "buyerName"=>"Nolan L Evans", "signature"=>"+z6x+1Ms+XMmO/HaoVqfPX0s2XlBePciU5ocyZYsdxcpqWTJWWSN+CuqMi2x3yxpakuL97LtCBiwt4DFTW5lIrgHlWzQKeW288tLGzu3ZWAV3hLfzCKmJKcAgrpmylQHhf1WbREgE2dU7f/KPlnZ+hi9kxAGgubm0AuIAb2GQEOfALA59FI1s7eJCP9WBKqzrSy8BHdgooWFbCCm49xwcPtwQ0UcV1qH3ff9Y0s5N7A+cdU7CN2UquAazSerbMxv9286cUbFjA3viNTgj6fTpPrdfyC5xMk+mRcuAI6aWax263VHvneNnqsLKWxfW7lKpqfIyQts167a3/9p7IjZQ==", "transactionId"=>"21277589Z541Z28C6J368HQQ4G8F38FG8I6", "paymentReason"=>"Gear My Toon Trial Account", "signatureVersion"=>"2", "transactionAmount"=>"USD 1", "recipientName"=>"Test Business", "transactionDate"=>"1277589054", "certificateUrl"=>"https://fps.sandbox.amazonaws.com/certs/090909/PKICert.pem", "signatureMethod"=>"RSA-SHA1", "operation"=>"pay", "recipientEmail"=>"gearmytoon@gmail.com", "buyerEmail"=>"nolane@gmail.com"}
      url_end_point = "http://localhost:3000/payment/receipt"
      assert_false SignatureUtilsForOutbound.new.validate_request(:parameters => payment_params, :url_end_point => url_end_point, :http_method => "GET")
    end
    
  end
end
