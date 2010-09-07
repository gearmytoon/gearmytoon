require File.dirname(__FILE__) + '/../test_helper'

#TODO test icon
class ItemImporterTest < ActiveSupport::TestCase
  context "exceptions" do
    should "be okay if thottbot errors out" do
      ItemSocketImporter.any_instance.stubs(:new).with(32837).raises("wtf bbq")
      item = ItemImporter.import_from_wowarmory!(32837)
    end
  end
  
  context "import_from_wowarmory!" do

    should "import caster cloak correctly" do
      item = ItemImporter.import_from_wowarmory!(50468)
      expected = {:stamina => 69, :intellect => 69, :crit => 52, :mana_regen => 30, :spell_power => 97, :armor=>177}
      assert_equal expected, item.bonuses
    end

    should "import item with block rating correctly" do
      item = ItemImporter.import_from_wowarmory!(50729)
      expected = {:strength => 102, :stamina => 141, :defense => 54, :parry => 46, :armor=>9262, :block => 7, :block_value => 6}
      assert_equal expected, item.bonuses
    end

    should "import item with parry correctly" do
      item = ItemImporter.import_from_wowarmory!(50846)
      expected = {:strength => 107, :stamina => 148, :defense => 56, :dodge => 48, :parry => 56, :armor=>1894}
      assert_equal expected, item.bonuses
    end

    should "import tank cloak correctly" do
      item = ItemImporter.import_from_wowarmory!(50466)
      expected = {:strength => 90, :stamina => 124, :defense => 48, :dodge => 48, :armor=>737}
      assert_equal expected, item.bonuses
    end

    should "import expertise item correctly" do
      item = ItemImporter.import_from_wowarmory!(37642)
      expected = {:stamina => 51, :agility => 49, :expertise => 33, :attack_power => 100}
      assert_equal expected, item.bonuses
    end

    should "import items with damage data but nothing else" do
      item = ItemImporter.import_from_wowarmory!(37708) #this item is a funny quest item with damage data
    end

    should "import items with multiple spell effects correct" do
      item = ItemImporter.import_from_wowarmory!(36737)
      item.reload
      assert_equal 2, item.spell_effects.size
    end
    
    should "not raise error on item not found" do
      STDERR.expects(:puts)
      item = ItemImporter.import_from_wowarmory!(36745)
    end
    
    should "import heirloom items correctly" do
      item = ItemImporter.import_from_wowarmory!(44091)
      assert_equal 1, item.item_level
      assert_equal 1, item.required_level_min
      assert_equal 80, item.required_level_max
      assert item.account_bound?
    end
    
    should "not duplicate item sources" do
      assert_difference "PurchaseSource.count", 3 do
        assert_difference "ItemSource.count", 3 do
          ItemImporter.import_from_wowarmory!(51153)
        end
      end
      assert_no_difference "PurchaseSource.count" do
        assert_no_difference "ItemSource.count" do
          ItemImporter.import_from_wowarmory!(51153)
        end
      end
    end

    should "destroy upgrades on re-import" do
      item = ItemImporter.import_from_wowarmory!(47261)
      Factory(:upgrade, :new_item_source => item.item_sources.first)
      assert_difference "Upgrade.count", -1 do
        ItemImporter.import_from_wowarmory!(47261)
      end
    end

    should "import multiple cost items correctly" do
      item = nil
      assert_difference "PurchaseSource.count", 3 do
        assert_difference "ItemSource.count", 3 do
          item = ItemImporter.import_from_wowarmory!(51153)
        end
      end
      item.reload
      purchase_source = item.item_sources.first
      item.item_sources.each do |purchase_source|
        assert_equivalent([52026,50115], purchase_source.items_used_to_purchase.map(&:wowarmory_item_id))
        assert_equal([1,1], purchase_source.items_used_to_purchase.map(&:quantity))
        vendor = purchase_source.vendor
        assert_not_nil vendor.name
        assert_not_nil vendor.classification
        assert_not_nil vendor.creature_type
        assert_not_nil vendor.wowarmory_creature_id
        assert_not_nil vendor.min_level
        assert_not_nil vendor.max_level
      end
    end

    should "import container items correctly" do
      item = nil
      assert_difference "ContainerSource.count" do
        assert_difference "ItemSource.count" do
          item = ItemImporter.import_from_wowarmory!(51910)
        end
      end
      item.reload
      container_source = item.item_sources.first
      assert container_source.is_a?(ContainerSource)
      assert_equal "4", container_source.drop_rate
      container = container_source.container
      assert_equal "Icecrown Citadel (10)", container.area.name
      assert_equal  Area::HEROIC, container.area.difficulty
      assert_equal "Gunship Armory", container.name
      assert_equal 202177, container.wowarmory_container_id
    end
    
    should "import quest items correctly" do
      item = nil
      assert_difference "QuestSource.count", 3 do
        assert_difference "ItemSource.count", 3 do
          item = ItemImporter.import_from_wowarmory!(50048)
        end
      end
      item.reload
      quest_source = item.item_sources.first
      assert quest_source.is_a?(QuestSource)
      quest = quest_source.quest
      assert_equal "Icecrown", quest.area.name
      assert_equal 80, quest.level
      assert_equal "A Victory For The Silver Covenant", quest.name
      assert_equal 80, quest.required_min_level
      assert_equal "0", quest.suggested_party_size
      assert_equal 24796, quest.wowarmory_quest_id
    end
    
    should "import tradecraft items correctly" do
      item = nil
      expected_wowarmory_item_ids = [37663, 35627, 49908]
      assert_difference "CreatedSource.count" do
        assert_difference "ItemSource.count" do
          item = ItemImporter.import_from_wowarmory!(49903)
        end
      end
      item.reload
      item_source = item.item_sources.first
      assert_equal Item::BOE, item.bonding
      assert_equal 'trade_blacksmithing', item_source.trade_skill.wowarmory_name
      assert_equal 3, item_source.items_made_from.size
      expected_quantities = [8, 12, 20]
      assert_equivalent expected_quantities, item_source.items_made_from.map(&:quantity)
      assert_equivalent expected_wowarmory_item_ids, item_source.items_made_from.map(&:wowarmory_item_id)
    end
    
    should "import item difficulty correctly" do
      item = ItemImporter.import_from_wowarmory!(50638)
      assert_equal 80, item.required_level
      assert_equal 277, item.item_level
      assert_equal true, item.heroic
      assert_equal Item::ANY_SIDE, item.side
      assert_equal nil, item.opposing_sides_wowarmory_item_id
    end
        
    should "import item level stuff correctly" do
      item = ItemImporter.import_from_wowarmory!(50034)
      assert_equal 80, item.required_level
      assert_equal 264, item.item_level
      assert_equal false, item.heroic
    end
    
    should "import spell effects correctly" do
      item = ItemImporter.import_from_wowarmory!(50198) #chance on hit
      item.reload
      assert_equal [{:trigger => 1, :description => "Chance on melee or ranged critical strike to increase your armor penetration rating by 678 for 10 sec."}], item.spell_effects
      item = ItemImporter.import_from_wowarmory!(50364) #must use to trigger
      assert_equal [{:trigger => 0, :description => "Increases resistance to Arcane, Fire, Frost, Nature, and Shadow spells by 268 for 10 sec."}], item.spell_effects
    end
      
    should "import trinkets with stamina correctly" do
      item = ItemImporter.import_from_wowarmory!(50364)
      assert_equal 258, item.bonuses[:stamina]
    end
    
    should "import trinkets with armor correctly" do
      item = ItemImporter.import_from_wowarmory!(54591)
      assert_equal 80, item.required_level
      assert_equal 2576, item.armor
      assert_equal 284, item.item_level
    end
    
    should_eventually "import patterns correctly" do
      item = ItemImporter.import_from_wowarmory!(47638)
      assert_equal [], item.emblem_sources
    end
    
    should "import offhands correctly" do
      item = ItemImporter.import_from_wowarmory!(50173)
      assert_equal "Off Hand", item.slot
    end
    
    should "import sheilds correctly" do
      item = ItemImporter.import_from_wowarmory!(50616)
      assert_equal "Shield", item.slot
    end
    
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
      honor_source = HonorSource.last
      assert_equal item, honor_source.item
      assert_not_nil honor_source.vendor
    end
    
    should "import tier 9 pants correctly" do
      assert_difference "DroppedSource.count" do
        item = ItemImporter.import_from_wowarmory!(48258)
        assert_equal "Vault of Archavon", item.dropped_sources.first.creature.area.name
        assert_equal Area::HEROIC, item.dropped_sources.first.creature.area.difficulty
      end
    end
    
    should "import a gems distinct kind of bonus" do
      item = ItemImporter.import_from_wowarmory!(45862)
      assert_equal({:strength => 20}, item.bonuses)
      assert_equal("Red", item.gem_color)
      assert(item.is_a?(GemItem))
      item = ItemImporter.import_from_wowarmory!(40032)
      assert_equal({:parry => 8, :stamina => 12}, item.bonuses)
      assert_equal("Purple", item.gem_color)
      assert(item.is_a?(GemItem))
      item = ItemImporter.import_from_wowarmory!(40175)
      assert_equal({:mana_regen => 5, :intellect => 10}, item.bonuses)
      assert_equal("Green", item.gem_color)
      assert(item.is_a?(GemItem))
      item = ItemImporter.import_from_wowarmory!(32225)
      assert_equal({:mana_regen => 3, :intellect => 5}, item.bonuses)
      assert_equal("Green", item.gem_color)
      assert(item.is_a?(GemItem))
      item = ItemImporter.import_from_wowarmory!(40147)
      assert_equal({:agility => 10, :crit => 10}, item.bonuses)
      assert_equal("Orange", item.gem_color)
      assert(item.is_a?(GemItem))
      item = ItemImporter.import_from_wowarmory!(40154)
      assert_equal({:spell_power => 12, :resilience => 10}, item.bonuses)
      assert_equal("Orange", item.gem_color)
      assert(item.is_a?(GemItem))
      item = ItemImporter.import_from_wowarmory!(40158)
      assert_equal({:attack_power => 20, :resilience => 10}, item.bonuses)
      assert(item.is_a?(GemItem))
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
      
    should "import items bindings" do
      item = ItemImporter.import_from_wowarmory!(36766)
      assert_equal Item::BOP, item.bonding
      item = ItemImporter.import_from_wowarmory!(40111)
      assert_equal Item::BOE, item.bonding
    end
      
    should "import meta gems with runspeed enchants correctly" do
      item = ItemImporter.import_from_wowarmory!(41339)
      assert_equal "Meta", item.gem_color
      assert(item.is_a?(GemItem))
      assert_equal({:attack_power => 42}, item.bonuses)
    end
      
    should "be able to import meta gems raw attributes" do
      item = ItemImporter.import_from_wowarmory!(41380)
      assert_equal({:stamina => 32}, item.bonuses)
      assert_equal("Meta", item.gem_color)
      assert(item.is_a?(GemItem))
      item = ItemImporter.import_from_wowarmory!(44088)
      assert_equal({:stamina => 26}, item.bonuses)
    end
      
    should "import gems correctly" do
      gems = [40032, 41380, 39976]
      gems.each do |gem|
        assert_difference "Item.count" do
          item = ItemImporter.import_from_wowarmory!(gem)
        end
      end
    end
    
    should "import items from events correctly" do
      assert_equal "Shadowfang Keep", ItemImporter.import_from_wowarmory!(51807).dropped_sources.first.creature.area.name
      assert_equal "Blackrock Depths", ItemImporter.import_from_wowarmory!(49074).dropped_sources.first.creature.area.name
    end
    
    should "import item with arena source correctly" do
      raid = Factory(:raid, :name => "Vault of Archavon")
      item = nil
      assert_difference "ArenaSource.count",12 do
        item = ItemImporter.import_from_wowarmory!(41206)
      end
      arena_source = ArenaSource.last
      assert_equal 770, arena_source.arena_point_cost
      assert_equal 13200, arena_source.honor_point_cost
      assert_not_nil arena_source.vendor
    end
    
    should "import gladiator gloves that have 4 sources" do
      raid = Factory(:raid, :name => "Vault of Archavon", :difficulty => Area::NORMAL, :wowarmory_area_id => 4603)
      item = nil
      assert_no_difference "HonorSource.count" do
        assert_difference "ArenaSource.count",12 do
          assert_difference "DroppedSource.count", 2 do
            item = ItemImporter.import_from_wowarmory!(41206)
          end
        end
      end
      assert_equal 770, ArenaSource.first.arena_point_cost
      assert_equal 13200, ArenaSource.first.honor_point_cost
      assert_equal raid, DroppedSource.first.creature.area
    end

    should "import pvp items that cost wintergrasp emblems" do
      item = ItemImporter.import_from_wowarmory!(51577)
      
      purchase_source = item.item_sources.first
      assert_equal 1, purchase_source.items_used_to_purchase.size
      currency_item = purchase_source.items_used_to_purchase.first
      assert_equal 40, currency_item.quantity
      assert_equal Item::WINTERGRASP_MARK_OF_HONOR, currency_item.wowarmory_item_id
      assert_equal item, PurchaseSource.last.item
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
      assert_equal Item::RESTRICT_TO_NONE, caster_item.restricted_to
      assert_equal [caster_item], Item.usable_by(WowClass.create_class!("Mage"))
      assert_equal [caster_item], Item.usable_by(WowClass.create_class!("Priest"))
      assert_equal [], Item.usable_by(WowClass.create_class!("Rogue"))
    end
    
    should "know if a item is for any side" do
      any_side_item = ItemImporter.import_from_wowarmory!(50776) #Both Sides
      assert_equal Item::ANY_SIDE, any_side_item.side
    end
    
    should "know if a item is for alliance or horde" do
      horde_item = ItemImporter.import_from_wowarmory!(48277) #48277 - horde hat
      alliance_item = ItemImporter.import_from_wowarmory!(48250) #48250 - alliance hat
      assert_equal Item::HORDE, horde_item.side
      assert_equal 48250, horde_item.opposing_sides_wowarmory_item_id
      assert_equal Item::ALLIANCE, alliance_item.side
      assert_equal 48277, alliance_item.opposing_sides_wowarmory_item_id
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
      
    should "import a item with multiple sources drop difficulty correctly" do
      raid = Factory(:raid, :name => "Ulduar")
      item = nil
      assert_difference "DroppedSource.count", 34 do
        item = ItemImporter.import_from_wowarmory!(45543)
      end
      item.dropped_sources.each do |dropped_source|
        assert_equal "Ulduar", dropped_source.creature.area.name
        assert_equal "h", dropped_source.creature.area.difficulty
        creature = dropped_source.creature
        assert_not_nil creature.name
        assert_not_nil creature.classification
        assert_not_nil creature.creature_type
        assert_not_nil creature.wowarmory_creature_id
        assert_not_nil creature.min_level
        assert_not_nil creature.max_level
      end
    end
    
    should "import items with multiple sources" do
      item = ItemImporter.import_from_wowarmory!(50088)
      assert_equal 4, item.reload.item_sources.size
      assert_equal 1, DroppedSource.count
      #assert_equal 60, EmblemSource.last.token_cost
#      assert_equal 49426, EmblemSource.last.wowarmory_token_item_id #from emblem of frost
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
      assert_equal "inv_belt_69", item[:icon]
      assert_equal "Mail", item.armor_type.name
    end
      
    should "import a items source" do
      assert_difference "Item.count" do
        item = ItemImporter.import_from_wowarmory!(47732)
        assert_equal "Band of the Invoker", item.name
        purchase_source = item.item_sources.first
        assert_equal 1, purchase_source.items_used_to_purchase.size
        assert_equal 47241, purchase_source.items_used_to_purchase.first.wowarmory_item_id
      end
    end
      
    should "import a items normal mode dungeon" do
      item = ItemImporter.import_from_wowarmory!(47232)
      assert_equal "Drape of the Undefeated", item.name
      area = item.item_sources.first.creature.area
      assert Area::DUNGEONS.include?(area.wowarmory_area_id)
      assert_equal "Trial of the Champion", area.name
      assert_equal "n", area.difficulty
    end
      
    should "import a items heroic dungeon" do
      rondel = ItemImporter.import_from_wowarmory!(49682)
      drape = ItemImporter.import_from_wowarmory!(47232)
      assert_equal "Black Knight's Rondel", rondel.name
      rondel_area = rondel.item_sources.first.creature.area
      assert_not_equal rondel_area, drape.item_sources.first.creature.area
      assert Area::DUNGEONS.include?(rondel_area.wowarmory_area_id)
      assert_equal "Trial of the Champion", rondel_area.name
      assert_equal "h", rondel_area.difficulty
    end
      
    should "import items from a normal 10 and 25 man raid" do
      ten_man_item = ItemImporter.import_from_wowarmory!(50966)
      twenty_five_man_item = ItemImporter.import_from_wowarmory!(50429)
      assert_equal "Abracadaver", ten_man_item.name
      assert_equal "Archus, Greatstaff of Antonidas", twenty_five_man_item.name
      ten_man_area = ten_man_item.item_sources.first.creature.area
      twenty_five_man_area = twenty_five_man_item.item_sources.first.creature.area
      assert_not_equal ten_man_area, twenty_five_man_area
      assert Area::RAIDS.include?(ten_man_area.wowarmory_area_id)
      assert Area::RAIDS.include?(twenty_five_man_area.wowarmory_area_id)
      assert_equal "Icecrown Citadel (10)", ten_man_area.name
      assert_equal "Icecrown Citadel (25)", twenty_five_man_area.name
      assert_equal "n", ten_man_area.difficulty
      assert_equal "n", twenty_five_man_area.difficulty
    end
    
    should "import items from a heroic 10 and 25 man raid" do
      ten_man_item = ItemImporter.import_from_wowarmory!(51876)
      twenty_five_man_item = ItemImporter.import_from_wowarmory!(50731)
      ten_man_area = ten_man_item.item_sources.first.creature.area
      twenty_five_man_area = twenty_five_man_item.item_sources.first.creature.area
      
      assert_not_equal ten_man_area, twenty_five_man_area
      assert Area::RAIDS.include?(ten_man_area.wowarmory_area_id)
      assert Area::RAIDS.include?(twenty_five_man_area.wowarmory_area_id)
      assert_equal "Icecrown Citadel (10)", ten_man_area.name
      assert_equal "Icecrown Citadel (25)", twenty_five_man_area.name
      assert_equal "h", ten_man_area.difficulty
      assert_equal "h", twenty_five_man_area.difficulty
    end
    
    should "import a items cost" do
      assert_difference "Item.count" do
        item = ItemImporter.import_from_wowarmory!(50979)
        purchase_source = item.item_sources.first
        assert_equal "Logsplitters", item.name
        assert_equal 1, purchase_source.items_used_to_purchase.size
        assert_equal 60, purchase_source.items_used_to_purchase.first.quantity
      end
    end
      
    should "import a items bonuses" do
      item = ItemImporter.import_from_wowarmory!(50270)
      expected_bonuses = {:intellect=>37, :attack_power=>130, :haste=>54, :agility=>89, :hit=>47, :stamina=>76, :armor => 746}
      item.reload
      assert_equal expected_bonuses, item.bonuses
    end
  end
end

