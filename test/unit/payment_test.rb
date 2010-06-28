require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < ActiveSupport::TestCase
  context "recurring?" do
    should "know if it is a recurring billing" do
      payment = Factory(:paid_payment)
      assert payment.recurring?
    end

    should "know if it is a not a recurring billing" do
      payment = Factory(:one_time_paid_payment)
      assert_false payment.recurring?
    end
  end

  should "get price from transactionAmount" do
    payment = Factory(:paid_payment, :raw_data => {"transactionAmount" => "USD 4"})
    assert_equal "4", payment.paid_amount
  end

end
