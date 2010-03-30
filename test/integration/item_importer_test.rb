require File.dirname(__FILE__) + '/../test_helper'

class ItemImporterTest < ActiveSupport::TestCase
  context "import_from_wowarmory!" do
    should "not import duplicates" do
      ItemImporter.import_from_wowarmory!(50270)
      assert_no_difference "Item.count" do
        ItemImporter.import_from_wowarmory!(50270)
      end
    end
    
    should_eventually "treat dress chests and breastplates as the same kind of chest" do
      vest = ItemImporter.import_from_wowarmory!(50087)
      dress = ItemImporter.import_from_wowarmory!(51145)
      assert_equal dress.inventory_type, vest.inventory_type
    end

    should_eventually "import items with multiple drops correctly" do
      item = ItemImporter.import_from_wowarmory!(45543)
      p item
      p item.source_area
      assert_not_nil item.source_area.name
      assert_equal "Ulduar", item.source_area.name
      assert_equal "h", item.source_area.difficulty #25 man ulduar
    end
    
    should "import melee weapon dps" do
      item = ItemImporter.import_from_wowarmory!(49682)
      assert_equal "Black Knight's Rondel", item.name
      assert_equal 235, item.bonuses[:melee_min_damage]
      assert_equal 353, item.bonuses[:melee_max_damage]
      assert_equal 1.8, item.bonuses[:melee_attack_speed]
      assert_equal 163.33, item.bonuses[:melee_dps]
    end

    should "import ranged bow weapon dps" do
      item = ItemImporter.import_from_wowarmory!(50776)
      assert_equal "Njorndar Bone Bow", item.name
      assert_equal 490, item.bonuses[:ranged_min_damage]
      assert_equal 814, item.bonuses[:ranged_max_damage]
      assert_equal 2.9, item.bonuses[:ranged_attack_speed]
      assert_equal 224.89, item.bonuses[:ranged_dps]
    end

    should "import ranged thrown weapon dps" do
      item = ItemImporter.import_from_wowarmory!(47659)
      assert_equal "Crimson Star", item.name
      assert_equal 368, item.bonuses[:ranged_min_damage]
      assert_equal 552, item.bonuses[:ranged_max_damage]
      assert_equal 1.8, item.bonuses[:ranged_attack_speed]
    end

    should "import basic item attributes" do
      item = ItemImporter.import_from_wowarmory!(50270)
      assert_equal "Belt of Rotted Fingernails", item.name
      assert_equal 6, item.inventory_type
      assert_equal "epic", item.quality
      assert_equal "http://www.wowarmory.com/wow-icons/_images/43x43/inv_belt_69.png", item.icon
      assert_equal "Mail", item.armor_type.name
    end

    should "import a items source" do
      assert_difference "Item.count" do
        item = ItemImporter.import_from_wowarmory!(47732)
        assert_equal "Band of the Invoker", item.name
        assert_equal 47241, item.source_wowarmory_item_id
      end
    end

    should "import a items normal mode dungeon" do
      item = ItemImporter.import_from_wowarmory!(47232)
      assert_equal "Drape of the Undefeated", item.name
      assert_not_nil item.source_area
      assert Area::DUNGEONS.include?(item.source_area.wowarmory_area_id)
      assert_equal "Trial of the Champion", item.source_area.name
      assert_equal "n", item.source_area.difficulty
    end

    should "import a items heroic dungeon" do
      rondel = ItemImporter.import_from_wowarmory!(49682)
      drape = ItemImporter.import_from_wowarmory!(47232)
      assert_equal "Black Knight's Rondel", rondel.name
      assert_not_nil rondel.source_area
      assert_not_equal rondel.source_area, drape.source_area
      assert Area::DUNGEONS.include?(rondel.source_area.wowarmory_area_id)
      assert_equal "Trial of the Champion", rondel.source_area.name
      assert_equal "h", rondel.source_area.difficulty
    end

    should "import items from a normal 10 and 25 man raid" do
      ten_man_item = ItemImporter.import_from_wowarmory!(50966)
      twenty_five_man_item = ItemImporter.import_from_wowarmory!(50429)
      assert_equal "Abracadaver", ten_man_item.name
      assert_equal "Archus, Greatstaff of Antonidas", twenty_five_man_item.name
      assert_not_equal ten_man_item.source_area, twenty_five_man_item.source_area
      assert Area::RAIDS.include?(ten_man_item.source_area.wowarmory_area_id)
      assert Area::RAIDS.include?(twenty_five_man_item.source_area.wowarmory_area_id)
      assert_equal "Icecrown Citadel (10)", ten_man_item.source_area.name
      assert_equal "Icecrown Citadel (25)", twenty_five_man_item.source_area.name
      assert_equal "n", ten_man_item.source_area.difficulty
      assert_equal "n", twenty_five_man_item.source_area.difficulty
    end
    should "import items from a heroic 10 and 25 man raid" do
      ten_man_item = ItemImporter.import_from_wowarmory!(51876)
      twenty_five_man_item = ItemImporter.import_from_wowarmory!(50731)
      assert_not_equal ten_man_item.source_area, twenty_five_man_item.source_area
      assert Area::RAIDS.include?(ten_man_item.source_area.wowarmory_area_id)
      assert Area::RAIDS.include?(twenty_five_man_item.source_area.wowarmory_area_id)
      assert_equal "Icecrown Citadel (10)", ten_man_item.source_area.name
      assert_equal "Icecrown Citadel (25)", twenty_five_man_item.source_area.name
      assert_equal "h", ten_man_item.source_area.difficulty
      assert_equal "h", twenty_five_man_item.source_area.difficulty
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

