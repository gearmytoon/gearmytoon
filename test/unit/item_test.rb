require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase
  context "from_emblem_of_triumph" do
    should "find all items that can be purchased with emblem_of_triumph" do
      item_from_emblem_of_triumph = Factory(:item_from_emblem_of_triumph)
      Factory(:item)
      assert_equal [item_from_emblem_of_triumph], Item.from_emblem_of_triumph
    end
  end

  context "from_emblem_of_frost" do
    should "find all items that can be purchased with emblem_of_triumph" do
      item_from_emblem_of_frost = Factory(:item_from_emblem_of_frost)
      Factory(:item)
      assert_equal [item_from_emblem_of_frost], Item.from_emblem_of_frost
    end
  end

end
