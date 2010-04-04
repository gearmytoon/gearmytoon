require 'test/test_helper'

class InviteTest < ActiveSupport::TestCase
  should_validate_presence_of :email

  should "generate an invitation code" do
    invite = Invite.create(:email => 'foo@bar.com')
    assert_not_nil invite.token
  end

  should "deliver the invitation email" do
    invite = Invite.create(:email => 'foo@bar.com')
    assert !ActionMailer::Base.deliveries.empty?
  end
end
