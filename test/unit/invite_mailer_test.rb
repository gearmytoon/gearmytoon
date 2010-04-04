require 'test/test_helper'

class InviteMailerTest < ActionMailer::TestCase
  should "send invite email" do
    invite = Invite.create(:email => 'foo@bar.com')
    email = InviteMailer.deliver_invite(invite)

    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [invite.email], email.to
    assert_equal "You've been invited to the Gear My Toon private beta", email.subject
    assert_match "http://gearmytoon.com/signup?invite%5Btoken%5D=#{invite.token}", email.body
  end
end
