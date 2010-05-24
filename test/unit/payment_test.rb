require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < ActiveSupport::TestCase
  should "know how much time is remaining in a payment" do
    payment = Factory(:paid_payment)
    freeze_time
    payment.update_attribute(:paid_at, 1.month.ago)
    assert_equal Time.now, payment.time_remaining
    payment.update_attribute(:paid_at, Time.now)
    assert_equal 1.month.from_now, payment.time_remaining
  end
end
