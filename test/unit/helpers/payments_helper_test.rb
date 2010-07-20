require File.dirname(__FILE__) + '/../../test_helper'

class PaymentsHelperTest < ActionView::TestCase
  def assert_select_in(html, *args, &block)
    node = HTML::Document.new(html).root
    assert_select(*args.unshift(node), &block)
  end
  should "build a standard pay form" do
    assert_select_in(standard_simple_pay_form(1), 'form[action=https://authorize.payments-sandbox.amazon.com/pba/paypipeline][method=POST]') do
      assert_select 'input[id=returnUrl][name=returnUrl][type=hidden][value=http://test.host/payment/receipt]'
      assert_select 'input[id=cobrandingStyle][name=cobrandingStyle][type=hidden][value=logo]'
      assert_select 'input[id=signatureVersion][name=signatureVersion][type=hidden][value=2]'
      assert_select 'input[id=abandonUrl][name=abandonUrl][type=hidden][value=http://test.host/payment]'
      assert_select 'input[id=immediateReturn][name=immediateReturn][type=hidden][value=1]'
      assert_select 'input[id=accessKey][name=accessKey][type=hidden][value=AKIAJDSU5CTXKVEMH6OA]'
      assert_select 'input[id=description][name=description][type=hidden][value=Gear My Toon Trial Account]'
      assert_select 'input[id=isDonationWidget][name=isDonationWidget][type=hidden][value=0]'
      assert_select 'input[id=amount][name=amount][type=hidden][value=USD 1]'
      assert_select 'input[id=collectShippingAddress][name=collectShippingAddress][type=hidden][value=0]'
      assert_select 'input[id=processImmediate][name=processImmediate][type=hidden][value=1]'
      assert_select 'input[id=signatureMethod][name=signatureMethod][type=hidden][value=HmacSHA1]'
      assert_select 'input[id=referenceId][name=referenceId][type=hidden][value=1]'
      assert_select 'input[id=signature][name=signature][type=hidden][value=/T/Rty4ra/70356YnKvYbZhPkbo=]'
      assert_select 'input[type=image][src=http://g-ecx.images-amazon.com/images/G/01/asp/beige_small_paynow_withlogo_darkbg.gif][border=0]'
    end
  end

  should "build a subscription pay form" do
    assert_select_in(subscription_simple_pay_form(2), 'form[action=https://authorize.payments-sandbox.amazon.com/pba/paypipeline][method=POST]') do
      assert_select 'input[id=recurringFrequency][name=recurringFrequency][type=hidden][value=1 month]'
      assert_select 'input[id=returnUrl][name=returnUrl][type=hidden][value=http://test.host/payment/receipt]'
      assert_select 'input[id=cobrandingStyle][name=cobrandingStyle][type=hidden][value=logo]'
      assert_select 'input[id=signatureVersion][name=signatureVersion][type=hidden][value=2]'
      assert_select 'input[id=abandonUrl][name=abandonUrl][type=hidden][value=http://test.host/payment]'
      assert_select 'input[id=immediateReturn][name=immediateReturn][type=hidden][value=1]'
      assert_select 'input[id=accessKey][name=accessKey][type=hidden][value=AKIAJDSU5CTXKVEMH6OA]'
      assert_select 'input[id=description][name=description][type=hidden][value=Gear My Toon Subscription]'
      assert_select 'input[id=amount][name=amount][type=hidden][value=USD 3]'
      assert_select 'input[id=collectShippingAddress][name=collectShippingAddress][type=hidden][value=0]'
      assert_select 'input[id=processImmediate][name=processImmediate][type=hidden][value=1]'
      assert_select 'input[id=signatureMethod][name=signatureMethod][type=hidden][value=HmacSHA1]'
      assert_select 'input[id=referenceId][name=referenceId][type=hidden][value=2]'
      assert_select 'input[id=signature][name=signature][type=hidden][value=UYChovQgo98YhRyME62soV+GvD8=]'
      assert_select 'input[type=image][src=http://g-ecx.images-amazon.com/images/G/01/asp/beige_small_subscribe_withlogo_darkbg.gif][border=0]'
    end
  end
end

