require File.dirname(__FILE__) + '/../test_helper'

class DroppedSourceTest < ActiveSupport::TestCase
  context "from_raids_10" do
    should "find items from 10 man raids" do
      Factory(:twenty_five_man_raid_source)
      expected = [Factory(:ten_man_raid_source)]
      assert_equal expected, DroppedSource.from_raids_10
    end
  end

  context "from_raids_25" do
    should "find items from 25 man raids" do
      Factory(:ten_man_raid_source)
      expected = [Factory(:twenty_five_man_raid_source)]
      assert_equal expected, DroppedSource.from_raids_25
    end
  end
end
