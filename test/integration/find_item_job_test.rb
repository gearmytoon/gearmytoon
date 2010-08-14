require File.dirname(__FILE__) + '/../test_helper'

class FindItemJobTest < ActiveSupport::TestCase
  should "import a item" do
    assert_difference "Item.count", 1 do
      FindItemJob.perform(47504)
    end
    assert_not_nil Item.find_by_wowarmory_item_id(47504)
    assert_equal "Barkhide Treads", Item.find_by_wowarmory_item_id(47504).name
  end
end
