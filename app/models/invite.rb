class Invite < ActiveRecord::Base
  before_create :generate_token
  after_create :send_invite_email

  validates_presence_of :email

  private
  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end

  def send_invite_email
    InviteMailer.send_later :deliver_invite, self
  end
end
