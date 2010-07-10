class UserCharacter < ActiveRecord::Base
  belongs_to :subscriber, :class_name => "User"
  belongs_to :character
  named_scope :paid_for, :include => {:subscriber => :payments}, :conditions => ["payments.paid_until > ? OR users.free_access = true", Time.now]
end
