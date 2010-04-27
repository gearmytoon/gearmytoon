# Amazon FPS Plugin
module AWS_FPS

  class Payment
    def self.prepare_call(caller, sender, recipient, amount, uid, reference)
      fps_call = { 'Action' => 'Pay',
            		# Tokens
            		'CallerTokenId' => caller,
            		'SenderTokenId' => sender,
            		'RecipientTokenId' => recipient,

            		# Transaction Details
            		'TransactionAmount.Amount' => amount, 
            		'TransactionAmount.CurrencyCode' => 'USD', 
            		'TransactionDate' => Time.now.gmtime.iso8601, # Example: 2007-05-10T13:08:02
            		'ChargeFeeTo' => 'Recipient', # Must match the true/false value from the recipient token

            		# Your Reference Codes / Numbers
            		'CallerReference' => 'Payment-' + uid,
            		'SenderReference' => 'Questions? Contact us and reference this ID: ' + uid, # Optional unique reference for the sender
            		'RecipientReference' => reference # Optional unique reference for the recipient
              }
      return fps_call
    end
  end

end