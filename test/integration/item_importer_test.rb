require File.dirname(__FILE__) + '/../test_helper'

class CharacterImporterTest < ActiveSupport::TestCase
  context "import_from_wowarmory!" do
    should "not import duplicates" do
      ItemImporter.import_from_wowarmory!(50270)
      assert_no_difference "Item.count" do
        ItemImporter.import_from_wowarmory!(50270)
      end
    end
    
    should "import basic item attributes" do
      item = ItemImporter.import_from_wowarmory!(50270)
      assert_equal "Belt of Rotted Fingernails", item.name
      assert_equal 6, item.inventory_type
      assert_equal 4, item.quality
      assert_equal "http://www.wowarmory.com/wow-icons/_images/43x43/inv_belt_69.png", item.icon
      assert_equal "Mail", item.armor_type.name
    end

    should "import a items source" do
      assert_difference "Item.count" do
        item = ItemImporter.import_from_wowarmory!(47732)
        assert_equal "Band of the Invoker", item.name
        assert_equal 47241, item.source_item_id
      end
    end

    should "not import items that cost more then triumph badges" do
      assert_no_difference "Item.from_emblem_of_triumph.count" do
        assert_difference "Item.count" do
          item = ItemImporter.import_from_wowarmory!(48223)
          assert_equal "VanCleef's Breastplate of Triumph", item.name
        end
      end
    end

    should "import a items cost" do
      assert_difference "Item.count" do
        item = ItemImporter.import_from_wowarmory!(50979)
        assert_equal "Logsplitters", item.name
        assert_equal 60, item.token_cost
      end
    end

    should "import a items bonuses" do
      item = ItemImporter.import_from_wowarmory!(50270)
      expected_bonuses = {:intellect=>37, :attack_power=>130, :haste=>54, :agility=>89, :hit=>47, :stamina=>76}
      item.reload
      assert_equal expected_bonuses, item.bonuses
    end
  end
end
