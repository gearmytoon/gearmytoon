class Payment < ActiveRecord::Base
  RECURRING = 'recurring'
  TRIAL = 'trial'
  belongs_to :purchaser, :class_name => "User"
  acts_as_state_machine :initial => :considering_payment, :column => "status"
  named_scope :paid, :conditions => {:status => "paid"}
  before_create :determine_plan_type
  
  serialize :raw_data
  state :considering_payment
  state :paid, :enter => Proc.new {|payment| payment.set_paid_until}
  state :failed

  event :pay do
    transitions :to => :paid, :from => :considering_payment
  end
  event :fail do
    transitions :to => :failed, :from => :considering_payment
  end

  def recurring?
    self.plan_type == RECURRING
  end
  
  def set_paid_until
    subscription_period = recurring? ? (1.month + 5.days) : (1.day + 5.hours)
    self.update_attribute(:paid_until, subscription_period.from_now)
  end
  
  def determine_plan_type
    self.plan_type = raw_data.include?("recurringFrequency") ? RECURRING : TRIAL
  end
  
  def paid_amount
    raw_data['transactionAmount'].gsub("USD\s","")
  end
end
