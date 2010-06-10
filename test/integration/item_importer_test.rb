require File.dirname(__FILE__) + '/../test_helper'

class ItemImporterTest < ActiveSupport::TestCase
  context "exceptions" do
    should "be okay if thottbot errors out" do
      ItemSocketImporter.any_instance.stubs(:new).with(32837).raises("wtf bbq")
      item = ItemImporter.import_from_wowarmory!(32837)
    end
  end

  context "import_from_wowarmory!" do
    should "not import previous seasons weapons with item sources" do
      item = ItemImporter.import_from_wowarmory!(45966)
      assert_equal [], item.item_sources
    end

    should "import emblem of frost correctly" do
      item = ItemImporter.import_from_wowarmory!(Item::FROST_EMBLEM_ARMORY_ID)
      assert_equal "epic", item.quality
    end
    
    should "import pvp items that are purchasable with honor" do
      item = ItemImporter.import_from_wowarmory!(41087)
      assert_equal 54500, item.item_sources.first.honor_point_cost
      assert_equal item, HonorSource.first.item
    end
    
    should "import tier 9 pants correctly" do
      assert_difference "DroppedSource.count" do
        item = ItemImporter.import_from_wowarmory!(48258)
        assert_equal "Vault of Archavon", item.dropped_sources.first.source_area.name
        assert_equal Area::NORMAL, item.dropped_sources.first.source_area.difficulty
      end
    end
    
    should "import a gems distinct kind of bonus" do
      item = ItemImporter.import_from_wowarmory!(45862)
      assert_equal({:strength => 20}, item.bonuses)
      assert_equal("Red", item.gem_color)
      item = ItemImporter.import_from_wowarmory!(40032)
      assert_equal({:parry => 8, :stamina => 12}, item.bonuses)
      assert_equal("Purple", item.gem_color)
      item = ItemImporter.import_from_wowarmory!(40175)
      assert_equal({:mana_regen => 5, :intellect => 10}, item.bonuses)
      assert_equal("Green", item.gem_color)
      item = ItemImporter.import_from_wowarmory!(32225)
      assert_equal({:mana_regen => 3, :intellect => 5}, item.bonuses)
      assert_equal("Green", item.gem_color)
      item = ItemImporter.import_from_wowarmory!(40147)
      assert_equal({:agility => 10, :crit => 10}, item.bonuses)
      assert_equal("Orange", item.gem_color)
      item = ItemImporter.import_from_wowarmory!(40154)
      assert_equal({:spell_power => 12, :resilience => 10}, item.bonuses)
      assert_equal("Orange", item.gem_color)
      item = ItemImporter.import_from_wowarmory!(40158)
      assert_equal({:attack_power => 20, :resilience => 10}, item.bonuses)
      item = ItemImporter.import_from_wowarmory!(40117)
      assert_equal({:armor_penetration => 20}, item.bonuses)
    end

    should "import a item without sockets as a empty array" do
      item = ItemImporter.import_from_wowarmory!(47272)
      assert_equal([], item.reload.gem_sockets)
    end

    should "import a items sockets" do
      item = ItemImporter.import_from_wowarmory!(50970)
      assert_equal(['Red', "Yellow", "Blue"], item.reload.gem_sockets)
      assert_equal({:agility => 8}, item.reload.socket_bonuses)
      item = ItemImporter.import_from_wowarmory!(47920)
      assert_equal(["Blue", "Yellow"], item.reload.gem_sockets)
      assert_equal({:haste => 6}, item.reload.socket_bonuses)
    end
    
    should "import prismatic gems correctly" do
      item = ItemImporter.import_from_wowarmory!(49110)
      assert_equal "Prismatic", item.gem_color
      assert_equal({:spirit => 10, :stamina => 10, :intellect => 10, :agility => 10, :strength => 10}, item.bonuses)
    end

    should "be able to import meta gems raw attributes" do
      item = ItemImporter.import_from_wowarmory!(41380)
      assert_equal({:stamina => 32}, item.bonuses)
      assert_equal("Meta", item.gem_color)
      item = ItemImporter.import_from_wowarmory!(44088)
      assert_equal({:stamina => 26}, item.bonuses)
    end

    should "import gems correctly" do
      gems = [40032, 41380, 39976]
      gems.each do |gem|
        assert_difference "Item.count" do
          assert_no_difference "ItemSource.count" do
            item = ItemImporter.import_from_wowarmory!(gem)
          end
        end
      end
    end
    
    should "import items from events correctly" do
      assert_equal "Shadowfang Keep", ItemImporter.import_from_wowarmory!(51807).dropped_sources.first.source_area.name
      assert_equal "Blackrock Depths", ItemImporter.import_from_wowarmory!(49074).dropped_sources.first.source_area.name
    end
    
    should "import gladiator gloves that have 4 sources" do
      raid = Factory(:raid, :name => "Vault of Archavon")
      item = nil
      assert_no_difference "HonorSource.count" do
        assert_difference "ArenaSource.count" do
          assert_difference "DroppedSource.count" do
            item = ItemImporter.import_from_wowarmory!(41206)
          end
        end
      end
      assert_equal 770, ArenaSource.first.arena_point_cost
      assert_equal 13200, ArenaSource.first.honor_point_cost
      assert_equal raid, DroppedSource.first.source_area
    end

    # ItemImporter.import_from_wowarmory!(41144)
    should_eventually "import gladiator gloves that have 4 sources" do
      item = ItemImporter.import_from_wowarmory!(41143)
      p item.item_sources
      p item.item_sources.size
      assert_equal [], item.item_sources
    end
    
    should "import pvp items that cost wintergrasp emblems" do
      item = ItemImporter.import_from_wowarmory!(51577)
      assert_equal 40, item.item_sources.first.token_cost
      assert_equal Item::WINTERGRASP_MARK_OF_HONOR, item.item_sources.first.wowarmory_token_item_id
      assert_equal item, EmblemSource.first.item
    end
    
    should "not import duplicates" do
      ItemImporter.import_from_wowarmory!(50270)
      assert_no_difference "Item.count" do
        ItemImporter.import_from_wowarmory!(50270)
      end
    end
    
    should "know if a item is only usable by a hunter" do
      hunter_item = ItemImporter.import_from_wowarmory!(51154)
      assert_equal [], Item.usable_by(WowClass.create_class!("Shaman"))
      assert_equal [hunter_item], Item.usable_by(WowClass.create_class!("Hunter"))
    end
    
    should "know if a item is only usable by more then one class" do
      caster_item = ItemImporter.import_from_wowarmory!(41898)
      assert_equal [caster_item], Item.usable_by(WowClass.create_class!("Mage"))
      assert_equal [caster_item], Item.usable_by(WowClass.create_class!("Priest"))
      assert_equal [], Item.usable_by(WowClass.create_class!("Rogue"))
    end
    
    should_eventually "know if a item is for alliance or horde" do
      #48277 - horde hat
      ItemImporter.import_from_wowarmory!(48277)
      #48250 - alliance hat
      ItemImporter.import_from_wowarmory!(48250)
      #item for both sides
      ItemImporter.import_from_wowarmory!(50776)
    end
    
    should "import bows crossbows guns and thrown as ranged slot" do
      bow = ItemImporter.import_from_wowarmory!(50776)
      assert_equal "Ranged", bow.slot
      crossbow = ItemImporter.import_from_wowarmory!(19361)
      assert_equal "Ranged", crossbow.slot
      gun = ItemImporter.import_from_wowarmory!(29949)
      assert_equal "Ranged", gun.slot
      thrown = ItemImporter.import_from_wowarmory!(34349)
      assert_equal "Ranged", thrown.slot
      wand = ItemImporter.import_from_wowarmory!(28588)
      assert_equal "Ranged", wand.slot
    end
    
    should "import wands correctly" do
      wand = ItemImporter.import_from_wowarmory!(28588)
      assert_equal "Ranged", wand.slot
      assert_equal "Wand", wand.armor_type.name
    end
    
    should "import quilts as legs slot" do
      legs = ItemImporter.import_from_wowarmory!(45384)
      assert_equal "Legs", legs.slot
    end
      
    should "import libram totem and idols correctly" do
      libram = ItemImporter.import_from_wowarmory!(50461)
      assert_equal "Libram", libram.armor_type.name
      assert_equal "Relic", libram.slot
      idol = ItemImporter.import_from_wowarmory!(35019)
      assert_equal "Idol", idol.armor_type.name
      assert_equal "Relic", idol.slot
      totem = ItemImporter.import_from_wowarmory!(50458)
      assert_equal "Totem", totem.armor_type.name
      assert_equal "Relic", totem.slot
      sigil = ItemImporter.import_from_wowarmory!(40207)
      assert_equal "Sigil", sigil.armor_type.name
      assert_equal "Relic", sigil.slot
    end
      
    should "import trinkets correctly" do
      trinket = ItemImporter.import_from_wowarmory!(50353)
      assert_equal "Miscellaneous", trinket.armor_type.name
      assert_equal "Trinket", trinket.slot
    end
      
    should "import polearms correctly" do
      polearm = ItemImporter.import_from_wowarmory!(50727)
      assert_equal "Polearm", polearm.armor_type.name
      assert_equal "Two-Hand", polearm.slot
    end
      
    should "import fist weapons correctly" do
      fist_weapon = ItemImporter.import_from_wowarmory!(51876)
      assert_equal "Fist Weapon", fist_weapon.armor_type.name
      assert_equal "Main Hand", fist_weapon.slot
    end
    
    should "treat dress chests and breastplates as the same kind of chest" do
      vest = ItemImporter.import_from_wowarmory!(50087)
      dress = ItemImporter.import_from_wowarmory!(51145)
      assert_equal "Leather", vest.armor_type.name
      assert_equal "Leather", dress.armor_type.name
      assert_equal "Chest", vest.slot
      assert_equal "Chest", dress.slot
    end
      
    should "import items with multiple drops correctly" do
      raid = Factory(:raid, :name => "Ulduar")
      item = nil
      assert_difference "DroppedSource.count" do
        item = ItemImporter.import_from_wowarmory!(45543)
        assert_equal "Ulduar", item.dropped_sources.first.source_area.name
      end
    end
    
    should_eventually "import a item with multiple sources drop difficulty correctly" do
      raid = Factory(:raid, :name => "Ulduar")
      item = nil
      assert_difference "DroppedSource.count" do
        item = ItemImporter.import_from_wowarmory!(45543)
        assert_equal "Ulduar", item.dropped_sources.first.source_area.name
        assert_equal "h", item.source_area.difficulty
      end
    end
    
    should "import items with multiple sources" do
      item = ItemImporter.import_from_wowarmory!(50088)
      assert_equal 2, item.reload.item_sources.size
      assert_equal 1, DroppedSource.count
      assert_equal 60, EmblemSource.first.token_cost
      assert_equal 49426, EmblemSource.first.wowarmory_token_item_id #from emblem of frost
    end
    
    should "import melee weapon dps" do
      item = ItemImporter.import_from_wowarmory!(49682)
      assert_equal "Black Knight's Rondel", item.name
      assert_equal "Dagger", item.armor_type.name
      assert_equal "One-Hand", item.slot
      assert_equal 235, item.bonuses[:melee_min_damage]
      assert_equal 353, item.bonuses[:melee_max_damage]
      assert_equal 1.8, item.bonuses[:melee_attack_speed]
      assert_equal 163.33, item.bonuses[:melee_dps]
    end
      
    should "import ranged bow weapon dps" do
      item = ItemImporter.import_from_wowarmory!(50776)
      assert_equal "Njorndar Bone Bow", item.name
      assert_equal "Bow", item.armor_type.name
      assert_equal 490, item.bonuses[:ranged_min_damage]
      assert_equal 814, item.bonuses[:ranged_max_damage]
      assert_equal 2.9, item.bonuses[:ranged_attack_speed]
      assert_equal 224.89, item.bonuses[:ranged_dps]
    end
      
    should "import ranged thrown weapon dps" do
      item = ItemImporter.import_from_wowarmory!(47659)
      assert_equal "Crimson Star", item.name
      assert_equal "Thrown", item.armor_type.name
      assert_equal 368, item.bonuses[:ranged_min_damage]
      assert_equal 552, item.bonuses[:ranged_max_damage]
      assert_equal 1.8, item.bonuses[:ranged_attack_speed]
    end
      
    should "import basic item attributes" do
      item = ItemImporter.import_from_wowarmory!(50270)
      assert_equal "Belt of Rotted Fingernails", item.name
      assert_equal "Mail", item.armor_type.name
      assert_equal "Waist", item.slot
      assert_equal "epic", item.quality
      assert_equal "http://www.wowarmory.com/wow-icons/_images/43x43/inv_belt_69.png", item.icon
      assert_equal "Mail", item.armor_type.name
    end
      
    should "import a items source" do
      assert_difference "Item.count" do
        item = ItemImporter.import_from_wowarmory!(47732)
        assert_equal "Band of the Invoker", item.name
        assert_equal 47241, item.emblem_sources.first.wowarmory_token_item_id
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
      assert_no_difference "EmblemSource.from_emblem_of_triumph.count" do
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

