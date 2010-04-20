require File.dirname(__FILE__) + '/../test_helper'

class DroppedSourceTest < ActiveSupport::TestCase
  context "from_raids_10" do
    should "find items from 10 man raids" do
      Factory(:item_from_25_man_raid)
      expected = [Factory(:item_from_10_man_raid)]
      assert_equal expected, DroppedSource.from_raids_10.map(&:item)
    end
  end

  context "from_raids_25" do
    should "find items from 25 man raids" do
      Factory(:item_from_10_man_raid)
      expected = [Factory(:item_from_25_man_raid)]
      assert_equal expected, DroppedSource.from_raids_25.map(&:item)
    end
  end
end
