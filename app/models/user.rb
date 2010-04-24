class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.session_ids = [nil,:admin]
  end
  has_many :payments, :foreign_key => :purchaser_id
  has_many :characters

  attr_protected :admin
end
