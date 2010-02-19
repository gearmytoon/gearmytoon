require File.dirname(__FILE__) + '/../test_helper'

class CharacterImporterTest < ActiveSupport::TestCase
  context "import_from_wowarmory!" do
    should "import basic item attributes" do
      item = nil
      assert_difference "Item.count" do
        item = ItemImporter.import_from_wowarmory!(50270)
      end
      assert_equal "Belt of Rotted Fingernails", item.name
      assert_equal 6, item.inventory_type
      assert_equal 4, item.quality
      assert_equal "http://www.wowarmory.com/wow-icons/_images/43x43/inv_belt_69.png", item.icon
    end

    should "import a items source" do
      item = nil
      assert_difference "Item.count" do
        item = ItemImporter.import_from_wowarmory!(47732)
      end
      assert_equal "Band of the Invoker", item.name
      assert_equal 47241, item.source_item_id
    end

    should "set dps if one is provided" do
      item = nil
      assert_difference "Item.count" do
        item = ItemImporter.import_from_wowarmory!(47732, 121)
      end
      assert_equal "Band of the Invoker", item.name
      assert_equal 121.0, item.dps
    end

  end
end
