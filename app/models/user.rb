class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.session_ids = [nil,:admin]
  end
  has_many :payments, :foreign_key => :purchaser_id
  has_many :user_characters, :foreign_key => :subscriber_id
  has_many :characters, :through => :user_characters

  has_one :most_recent_payment, :class_name => "Payment", :order => 'paid_at DESC', :foreign_key => :purchaser_id

  attr_protected :admin
  
  def active_subscriber?
    most_recent_payment.paid_at > 36.days.ago
  end
end
