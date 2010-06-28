class Payment < ActiveRecord::Base
  RECURRING = 'recurring'
  TRIAL = 'trial'
  belongs_to :purchaser, :class_name => "User"
  acts_as_state_machine :initial => :considering_payment, :column => "status"
  named_scope :paid, :conditions => {:status => "paid"}
  before_save :determine_plan_type
  
  serialize :raw_data
  state :considering_payment
  state :paid, :enter => Proc.new {|payment| payment.set_paid_until}
  state :failed

  event :pay do
    transitions :to => :paid, :from => [:considering_payment, :failed]
  end
  event :fail do
    transitions :to => :failed, :from => :considering_payment
  end

  def validate_payment(url_end_point, http_method)
    signiture_correct = SignatureUtilsForOutbound.new.validate_request(:parameters => raw_data, :url_end_point => url_end_point, :http_method => http_method)
    logger.error "signiture_correct: #{signiture_correct} for transaction: #{self.transaction_id}"
    if signiture_correct && successful_transaction?(raw_data["status"])
      self.pay!
    else
      self.fail!
    end
  end

  def successful_transaction?(status_code)
    amazon_success_codes = ["PS", "SS", "US", "SI", "PI", "PR"]
    amazon_success_codes.include?(status_code)
  end

  def recurring?
    self.plan_type == RECURRING
  end
  
  def set_paid_until
    subscription_period = recurring? ? (1.month + 5.days) : (1.day + 5.hours)
    self.update_attribute(:paid_until, subscription_period.from_now)
  end
  
  def determine_plan_type
    self.plan_type = raw_data.include?("subscriptionId") ? RECURRING : TRIAL
  end
  
  def paid_amount
    raw_data['transactionAmount'].gsub("USD\s","")
  end
end
