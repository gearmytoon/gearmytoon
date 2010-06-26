require File.dirname(__FILE__) + '/../../test_helper'

class PaymentsHelperTest < ActionView::TestCase

  #TODO: improve asserts
  should "build a standard pay form" do
    expected = '<form action="https://authorize.payments-sandbox.amazon.com/pba/paypipeline" method="POST"><input id="isDonationWidget" name="isDonationWidget" type="hidden" value="0" /><input id="returnUrl" name="returnUrl" type="hidden" value="http://test.host/payment/receipt" /><input id="cobrandingStyle" name="cobrandingStyle" type="hidden" value="logo" /><input id="signatureVersion" name="signatureVersion" type="hidden" value="2" /><input id="abandonUrl" name="abandonUrl" type="hidden" value="http://test.host/payment" /><input id="immediateReturn" name="immediateReturn" type="hidden" value="1" /><input id="accessKey" name="accessKey" type="hidden" value="AKIAJDSU5CTXKVEMH6OA" /><input id="description" name="description" type="hidden" value="Gear My Toon Trial Account" /><input id="amount" name="amount" type="hidden" value="USD 1" /><input id="collectShippingAddress" name="collectShippingAddress" type="hidden" value="0" /><input id="processImmediate" name="processImmediate" type="hidden" value="1" /><input id="signatureMethod" name="signatureMethod" type="hidden" value="HmacSHA1" /><input id="signature" name="signature" type="hidden" value="57f6DoX0wsSjz/iNzDUeur7ObFY=" /><input type="image" src="http://g-ecx.images-amazon.com/images/G/01/asp/beige_small_paynow_withlogo_darkbg.gif" border="0"/></form>'
    assert_equal expected, standard_simple_pay_form
  end

  should "build a subscription pay form" do
    expected = '<form action="https://authorize.payments-sandbox.amazon.com/pba/paypipeline" method="POST"><input id="recurringFrequency" name="recurringFrequency" type="hidden" value="1 month" /><input id="returnUrl" name="returnUrl" type="hidden" value="http://test.host/payment/receipt" /><input id="cobrandingStyle" name="cobrandingStyle" type="hidden" value="logo" /><input id="signatureVersion" name="signatureVersion" type="hidden" value="2" /><input id="abandonUrl" name="abandonUrl" type="hidden" value="http://test.host/payment" /><input id="immediateReturn" name="immediateReturn" type="hidden" value="1" /><input id="accessKey" name="accessKey" type="hidden" value="AKIAJDSU5CTXKVEMH6OA" /><input id="description" name="description" type="hidden" value="Gear My Toon Subscription" /><input id="amount" name="amount" type="hidden" value="USD 3" /><input id="collectShippingAddress" name="collectShippingAddress" type="hidden" value="0" /><input id="processImmediate" name="processImmediate" type="hidden" value="1" /><input id="signatureMethod" name="signatureMethod" type="hidden" value="HmacSHA1" /><input id="signature" name="signature" type="hidden" value="DNWbkVN0LXqKzWlgvCmQOYXHXSo=" /><input type="image" src="http://g-ecx.images-amazon.com/images/G/01/asp/beige_small_subscribe_withlogo_darkbg.gif" border="0" /></form>'
    assert_equal expected, subscription_simple_pay_form
  end
end

