require File.dirname(__FILE__) + '/../test_helper'

class ItemSourceTest < ActiveSupport::TestCase  
  should "delete upgrades with item source" do
    upgrade = Factory(:upgrade)
    assert_difference "Upgrade.count", -1 do
      assert_difference "ItemSource.count", -1 do
        upgrade.new_item_source.destroy
      end
    end
  end

  context "drop_rate_percent" do
    should "be 100% for a drop_rate of 6" do
      assert_equal "100%", ItemSource.new(:drop_rate => "6").drop_rate_percent
    end
    should "be 51-99% for a drop_rate of 5" do
      assert_equal "51-99%", ItemSource.new(:drop_rate => "5").drop_rate_percent
    end
    should "be 25-50% for a drop_rate of 4" do
      assert_equal "25-50%", ItemSource.new(:drop_rate => "4").drop_rate_percent
    end
    should "be 15-24% for a drop_rate of 3" do
      assert_equal "15-24%", ItemSource.new(:drop_rate => "3").drop_rate_percent
    end
    should "be 3-14% for a drop_rate of 2" do
      assert_equal "3-14%", ItemSource.new(:drop_rate => "2").drop_rate_percent
    end
    should "be 1-2% for a drop_rate of 1" do
      assert_equal "1-2%", ItemSource.new(:drop_rate => "1").drop_rate_percent
    end
    should "be ? for a drop_rate of nil" do
      assert_equal "?", ItemSource.new(:drop_rate => nil).drop_rate_percent
    end
  end
  
end
