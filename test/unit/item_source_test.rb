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
  
end
