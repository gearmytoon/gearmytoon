class InviteMailer < ActionMailer::Base
  def invite(invite)
    recipients invite.email
    from       'Gear My Toon <gearmytoon@gmail.com>'
    subject    "You've been invited to the Gear My Toon private beta"
    body       :invite => invite
  end
end
