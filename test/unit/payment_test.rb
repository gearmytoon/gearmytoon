require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < ActiveSupport::TestCase
  should "know how much time is remaining in a payment" do
    payment = Factory(:paid_payment)
    freeze_time
    payment.update_attribute(:paid_at, 1.month.ago + 7.days)
    assert_equal 7.days.from_now, payment.time_remaining
  end
end
