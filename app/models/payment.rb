class Payment < ActiveRecord::Base
  belongs_to :purchaser, :class_name => "User"
  acts_as_state_machine :initial => :considering_payment, :column => "status"
  named_scope :paid, :conditions => {:status => "paid"}

  state :considering_payment
  state :paid, :enter => Proc.new {|payment| payment.update_attribute(:paid_at, Time.now) }
  state :failed

  event :pay do
    transitions :to => :paid, :from => :considering_payment
  end
  event :fail do
    transitions :to => :failed, :from => :considering_payment
  end
  
  def time_remaining
    (paid_at + 1.month)
  end

  attr_accessible :recipient_token, :caller_reference, :caller_token
end
