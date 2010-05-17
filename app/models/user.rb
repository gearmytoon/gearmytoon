class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.session_ids = [nil,:admin]
  end
  has_many :payments, :foreign_key => :purchaser_id
  has_many :user_characters, :foreign_key => :subscriber_id
  has_many :characters, :through => :user_characters

  has_one :most_recent_paid_payment, :class_name => "Payment", :order => 'paid_at DESC', :foreign_key => :purchaser_id, :conditions => {:status => "paid"}
  
  attr_protected :admin
  
  def active_payment
    if most_recent_paid_payment && most_recent_paid_payment.time_remaining > Time.now
      most_recent_paid_payment
    end
  end
  
  def active_subscriber?
    most_recent_paid_payment && most_recent_paid_payment.paid_at > 36.days.ago
  end
end
