class Payment < ActiveRecord::Base
  belongs_to :purchaser, :class_name => "User"
  acts_as_state_machine :initial => :considering_payment, :column => "status"
  state :considering_payment
  state :paid
  event :pay do
    transitions :to => :paid, :from => :considering_payment
  end
  attr_accessible :recipient_token, :caller_reference, :caller_token
end
