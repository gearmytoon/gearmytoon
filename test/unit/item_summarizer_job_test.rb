require File.dirname(__FILE__) + '/../test_helper'

class ItemSummarizerJobTest < ActiveSupport::TestCase
  should "summarize an item" do
    item = Factory(:item)
    hunter = Factory(:a_hunter, :name => "bar")
    Factory(:character_item, :character => hunter, :item => item)
    assert_difference "ItemPopularity.count", 1 do
      ItemSummarizerJob.perform(item.id)
    end
  end
end