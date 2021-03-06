require File.dirname(__FILE__) + '/../test_helper'

class CharacterTest < ActiveSupport::TestCase
  context "named scopes" do
    should "return geared characters" do
      geared_characters = []
      3.times do |i|
        c = Factory(:character, :status => 'geared')
        c.found_upgrades!
        geared_characters << c
        Factory(:character)
      end
      assert_equal geared_characters, Character.geared
    end
  end
  context "associations" do
    should "serialize total_item_bonuses" do
      character = Factory(:character, :total_item_bonuses => {:hit => 25})
      assert_equal({:hit => 25}, character.reload.total_item_bonuses)
    end
    should_have_many :equipped_items
    should_have_many :character_items
    should_belong_to :spec
    should "have many equipped items through character_items" do
      character_item = Factory(:character_item)
      assert_equal [character_item.item], character_item.character.equipped_items
    end
  end

  context "validations" do
    should "not allow more than one character name per realm per locale" do
      character1 = Factory(:character, :name => 'Ecma', :realm => 'Baelgun', :locale => 'us')
      character2 = Character.new(:name => 'Ecma', :realm => 'Baelgun', :locale => 'us')
      assert !character2.valid?
    end

    should "allow characters with same name and same realm and different locale" do
      character1 = Factory(:character, :name => 'Ecma', :realm => 'Baelgun', :locale => 'us')
      character2 = Character.new(:name => 'Ecma', :realm => 'Baelgun', :locale => 'eu')
      assert character2.valid?
    end

    should_validate_presence_of :name
    should_validate_presence_of :realm
  end

  context "kind of upgrades" do
    should "not have a pvp upgrades method if it is a pve only kind of upgrade" do
      character = Factory(:a_hunter)
      assert character.respond_to?(:heroic_dungeon_upgrades)
      assert_false character.respond_to?(:heroic_dungeon_pvp_upgrades)
    end
    should "not have a pve upgrades method if it is a pvp only kind of upgrade" do
      character = Factory(:a_hunter)
      assert_false character.respond_to?(:honor_point_upgrades)
      assert character.respond_to?(:honor_point_pvp_upgrades)
    end

  end

  context "top_3_upgrades_from_area" do
    should "find upgrades from the specific area" do
      character = Factory(:a_hunter)
      upgrade = Factory(:upgrade_from_heroic_dungeon, :character => character)
      Factory(:upgrade_from_10_raid, :character => character)
      upgrades = character.area_upgrades(1, upgrade.new_item_source.creature.area)
      assert_equal [upgrade], upgrades
      assert_equal upgrades.length, character.top_3_area_upgrades(upgrade.new_item_source.creature.area).length
    end
  end

  context "generate_upgrades" do
    should "not find empty slot upgrades if the toon has a two handed weapon" do
      character = Factory(:a_hunter)
      Factory(:character_item, :character => character, :item => Factory(:polearm))
      Factory(:frost_emblem_source, :item => Factory(:fist_weapon))
      assert_no_difference "character.reload.upgrades.count" do
        character.generate_upgrades
      end
      assert_equal [], character.reload.frost_upgrades(1)
    end

    should "find two upgrades for both rings" do
      character = Factory(:a_hunter)
      no_dps_ring = Factory(:ring, :bonuses => {:attack_power => 0.0})
      Factory(:character_item, :character => character, :item => no_dps_ring)
      Factory(:character_item, :character => character, :item => no_dps_ring)
      new_dps_ring = Factory(:dungeon_dropped_source, :item => Factory(:ring, :bonuses => {:attack_power => 500.0})).item
      assert_difference "character.reload.upgrades.count", 2 do
        character.generate_upgrades
        assert_equal 2, character.reload.heroic_dungeon_upgrades(1).length
      end
      assert_equal no_dps_ring, character.heroic_dungeon_upgrades(1).first.old_item
      assert_equal new_dps_ring, character.heroic_dungeon_upgrades(1).first.new_item
    end

    should "find upgrades from heroic dungeons" do
      character = Factory(:a_hunter)
      Factory(:character_item, :character => character, :item => Factory(:item, :bonuses => {:attack_power => 100.0}))
      new_item_source = Factory(:dungeon_dropped_source, :item => Factory(:item, :bonuses => {:attack_power => 500.0}))
      assert_difference "character.reload.upgrades.count", 1 do
        character.generate_upgrades
      end
      assert_equal([new_item_source], character.reload.area_upgrades(1, new_item_source.creature.area).map(&:new_item_source))
    end

    should "not find two upgrades to the same item from heroic dungeons" do
      character = Factory(:a_hunter)
      Factory(:character_item, :character => character, :item => Factory(:item, :bonuses => {:attack_power => 100.0}))
      new_item = Factory(:item, :bonuses => {:attack_power => 500.0})
      Factory(:dungeon_dropped_source, :item => new_item)
      Factory(:dungeon_dropped_source, :item => new_item)
      assert_difference "character.reload.upgrades.count", 1 do
        character.generate_upgrades
      end
      assert_equal new_item, character.upgrades.first.new_item
    end

    should "find upgrades for pve and pvp" do
      character = Factory(:a_hunter)
      no_dps_ring = Factory(:ring, :bonuses => {:attack_power => 0.0})
      Factory(:character_item, :character => character, :item => no_dps_ring)
      Factory(:character_item, :character => character, :item => no_dps_ring)
      new_dps_ring = Factory(:frost_emblem_source, :item => Factory(:ring, :bonuses => {:attack_power => 500.0})).item
      assert_difference "character.reload.upgrades.count", 4 do
        character.generate_upgrades
      end
      assert_equal 2, character.reload.frost_upgrades(1).length
      assert_equal 2, character.reload.frost_pvp_upgrades(1).length
    end

    should "find upgrades of the same armor type" do
      rogue = Factory(:character_item, :character => Factory(:a_rogue)).character
      plate_upgrade = Factory(:dungeon_dropped_source, :item => Factory(:item, :bonuses => {:attack_power => 500.0}, :armor_type => ArmorType.plate)).item
      leather_upgrade = Factory(:dungeon_dropped_source, :item => Factory(:item, :bonuses => {:attack_power => 500.0}, :armor_type => ArmorType.leather)).item
      assert_difference "rogue.reload.upgrades.count", 1 do
        rogue.generate_upgrades
      end
      assert_equal 1, rogue.reload.top_3_heroic_dungeon_upgrades.size
      assert_equal leather_upgrade, rogue.top_3_heroic_dungeon_upgrades.first.new_item
    end

    should_eventually "find a upgrade if you do not have a inventory item in that slot"

    should "find upgrades of the Miscellaneous armor type for any character" do
      rogue = Factory(:character_item, :character => Factory(:a_rogue)).character
      upgrade = Factory(:dungeon_dropped_source, :item => Factory(:item, :bonuses => {:attack_power => 500.0}, :armor_type => ArmorType.miscellaneous)).item
      assert_difference "rogue.reload.upgrades.count", 1 do
        rogue.generate_upgrades
      end
      assert_equal 1, rogue.top_3_heroic_dungeon_upgrades.size
      assert_equal upgrade, rogue.top_3_heroic_dungeon_upgrades.first.new_item
    end
  end

  context "top_3_frost_upgrades" do
    should "order the upgrades by the dps increase" do
      mid_upgrade = Factory(:upgrade, :new_item_source => Factory(:frost_emblem_source, :item => Factory(:item, :bonuses => {:attack_power => 200.0})))
      character = mid_upgrade.character
      big_upgrade = Factory(:upgrade, :new_item_source => Factory(:frost_emblem_source, :item => Factory(:item, :bonuses => {:attack_power => 500.0})), :character => character)
      upgrades = [big_upgrade, mid_upgrade]
      assert_equal upgrades.map(&:id), character.top_3_frost_upgrades.map(&:id)
    end

    should "find only the first 3 upgrades" do
      character = Factory(:a_hunter)
      4.times { Factory(:upgrade_from_emblem_of_frost,:character => character)}
      assert_equal 3, character.top_3_frost_upgrades.length
    end
  end

  context "top_3_triumph_upgrades" do
    should "order the upgrades by the dps increase" do
      mid_upgrade = Factory(:upgrade, :new_item_source => Factory(:triumph_emblem_source, :item => Factory(:item, :bonuses => {:attack_power => 200.0})))
      character = mid_upgrade.character
      big_upgrade = Factory(:upgrade, :new_item_source => Factory(:triumph_emblem_source, :item => Factory(:item, :bonuses => {:attack_power => 500.0})), :character => character)
      upgrades = [big_upgrade, mid_upgrade]
      assert_equal upgrades.map(&:id), character.top_3_triumph_upgrades.map(&:id)
    end

    should "find the first 3 upgrades" do
      character = Factory(:a_hunter)
      4.times { Factory(:upgrade_from_emblem_of_triumph, :character => character) }
      assert_equal 3, character.top_3_triumph_upgrades.length
    end
  end

  context "top_3_heroic_dungeon_upgrades" do
    should "return three upgrades" do
      character = Factory(:a_hunter)
      4.times { Factory(:upgrade_from_heroic_dungeon, :character => character) }
      upgrades = character.top_3_heroic_dungeon_upgrades
      assert_equal 3, upgrades.size
    end

    should "only find items from heroic dungeons" do
      character = Factory(:a_hunter)
      upgrade = Factory(:upgrade_from_heroic_dungeon, :character => character)
      Factory(:upgrade_from_emblem_of_triumph, :character => character)
      upgrades = character.top_3_heroic_dungeon_upgrades
      assert_equal [upgrade], upgrades
    end
  end

  context "top_3_raid_10_upgrades" do
    should "return three upgrades" do
      character = Factory(:a_hunter)
      4.times { Factory(:upgrade_from_10_raid, :character => character) }
      upgrades = character.top_3_raid_10_upgrades
      assert_equal 3, upgrades.size
    end

    should "only find items from raids" do
      character = Factory(:a_hunter)
      upgrade = Factory(:upgrade_from_10_raid, :character => character)
      Factory(:upgrade_from_heroic_dungeon, :character => character)
      upgrades = character.top_3_raid_10_upgrades
      assert_equal [upgrade], upgrades
    end

  end
  context "top_3_honor_upgrades" do
    should "find top 3" do
      character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
      4.times{Factory(:upgrade_from_honor_points, :character => character)}
      upgrades = character.top_3_honor_point_pvp_upgrades
      assert_equal 3, upgrades.size
    end

    should "only find items from honor points" do
      upgrade = Factory(:upgrade_from_honor_points)
      character = upgrade.character
      Factory(:upgrade_from_10_raid, :character => character, :for_pvp => true)
      upgrades = character.top_3_honor_point_pvp_upgrades
      assert_equal 1, upgrades.size
      assert_equal upgrade.new_item, upgrades.first.new_item
    end
  end
  context "top_3_wintergrasp_upgrades" do
    should "only find items from honor points" do
      upgrade = Factory(:upgrade_from_wintergrasp_marks)
      character = upgrade.character
      Factory(:upgrade_from_10_raid, :character => character, :for_pvp => true)
      upgrades = character.top_3_wintergrasp_mark_pvp_upgrades
      assert_equal 1, upgrades.size
      assert_equal upgrade.new_item, upgrades.first.new_item
    end
  end

  context "top_3_arena_point_upgrades" do
    should "only find items from honor points" do
      upgrade = Factory(:upgrade_from_arena_points)
      character = upgrade.character
      Factory(:upgrade_from_10_raid, :character => character, :for_pvp => true)
      upgrades = character.top_3_arena_point_pvp_upgrades
      assert_equal 1, upgrades.size
      assert_equal upgrade.new_item, upgrades.first.new_item
    end
  end

  #this should go to a hunter dps forumla class eventually, it's own model
  context "convert_bonuses_to_dps" do
    setup do
      test_multipliers = {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}
      Rogue.any_instance.stubs(:stat_multipliers).returns(test_multipliers)
    end
    should "attack power should be worth 0.5 dps" do
      assert_equal 65.0, Factory(:a_rogue).dps_for({:attack_power => 130},false)
    end

    should "agility should be worth 1 dps" do
      assert_equal 89.0, Factory(:a_rogue).dps_for({:agility => 89},false)
    end

    should "hit should be worth 0.8 dps" do
      assert_equal 40.0, Factory(:a_rogue).dps_for({:hit => 50},false)
    end

    should "haste should be worth 0.7 dps" do
      assert_equal 35.0, Factory(:a_rogue).dps_for({:haste => 50},false)
    end

    should "crit should be worth 0.75 dps" do
      assert_equal 37.5, Factory(:a_rogue).dps_for({:crit => 50},false)
    end

    should "armor_penetration should be worth 1.1 dps" do
      assert_equal 55, Factory(:a_rogue).dps_for({:armor_penetration => 50},false).to_i
    end

  end

  context "dps_for" do
    should "know the relative dps for a item" do
      assert_equal 191.6, Factory(:a_rogue).dps_for({:attack_power => 130, :agility => 89, :hit => 47, :stamina => 76},false)
    end
  end

  context "hard_cap" do
    should "be 263 for hit for hunters" do
      character = Factory(:a_hunter)
      assert_equal 263, character.hard_caps[:hit]
    end

    should "be 886 for hit for rogues" do
      character = Factory(:a_rogue)
      assert_equal 886, character.hard_caps[:hit]
    end

  end

  context "paid?" do
    should "know if the character is paid for" do
      purchaser = Factory(:user)
      payment = Factory(:paid_payment, :purchaser => purchaser)
      character = Factory(:user_character, :subscriber => purchaser).character
      assert_equal [purchaser], character.subscribers
      assert character.paid?
    end
    should "know if the character is not paid for" do
      purchaser = Factory(:user)
      payment = Factory(:considering_payment, :purchaser => purchaser)
      character = Factory(:user_character, :subscriber => purchaser).character
      assert_equal [purchaser], character.subscribers
      assert_false character.paid?
    end

    should "know if the character is subscribed to by a free access account" do
      free_access_user = Factory(:free_access_user)
      character = Factory(:user_character, :subscriber => free_access_user).character
      assert character.paid?
    end

  end

  context "primary_spec" do
    should "be used to determine the characters multipliers" do
      survival_hunter = Factory(:survival_hunter)
      marks_hunter = Factory(:marksmanship_hunter)
      item = Factory(:item)
      assert_not_equal marks_hunter.dps_for(item.bonuses,false), survival_hunter.dps_for(item.bonuses,false)
    end
  end

  context "friendly_id" do
    should "be composed of name, realm, and locale" do
      c = Factory(:character, :name => "Foo", :realm => "Bar")
      assert_equal "foo-bar-us", c.friendly_id
    end
  end

  context "faction" do
    should "be horde for blood elf, orc, tauren, troll, undead" do
      ['orc', 'undead', 'troll', 'tauren', 'blood elf'].each do |race|
        assert_equal 'horde', Character.new(:race => race).faction
      end
    end

    should "be alliance for dwarf, gnome, human, night elf, dranei" do
      ['dwarf', 'gnome', 'human', 'night elf', 'draenei'].each do |race|
        assert_equal 'alliance', Character.new(:race => race).faction
      end
    end
  end

  context "status" do
    should "start as new" do
      character = Factory(:new_character)
      assert_equal "new", character.status
    end

    should "transition to and from geared" do
      character = Factory(:new_character)
      character.refreshing!
      assert_equal "being_refreshed", character.status
      character.loaded!
      assert_equal "found", character.status
      character.found_upgrades!
      assert_equal "geared", character.status
      character.refreshing!
      assert_equal "being_refreshed", character.status
    end

    should "transition to and from found" do
      character = Factory(:new_character)
      character.refreshing!
      assert_equal "being_refreshed", character.status
      character.loaded!
      assert_equal "found", character.status
      character.refreshing!
      assert_equal "being_refreshed", character.status
      character.unable_to_load!
      assert_equal "does_not_exist", character.status
      character.refreshing!
      assert_equal "being_refreshed", character.status
      character.loaded!
      assert_equal "found", character.status
      character.found_upgrades!
      assert_equal "geared", character.status
    end

    should "transition to and from does not exist" do
      character = Factory(:new_character)
      character.refreshing!
      assert_equal "being_refreshed", character.status
      character.unable_to_load!
      assert_equal "does_not_exist", character.status
      character.refreshing!
      assert_equal "being_refreshed", character.status
      character.loaded!
      assert_equal "found", character.status
    end
  end

  context "find_best_gem" do
    should "find the best gem for a character" do
      character = Factory(:a_hunter)
      best_gem = Factory(:red_gem, :bonuses => {:agility => 10})
      Factory(:red_gem, :bonuses => {:agility => 1})
      assert_equal best_gem, character.find_best_gem("Red",{}, false)
    end

    should "find the best gem for a character with any color" do
      character = Factory(:a_hunter)
      Factory(:red_gem, :bonuses => {:agility => 10})
      best_gem = Factory(:orange_gem, :bonuses => {:agility => 11, :crit => 11})
      assert_equal best_gem, character.find_best_gem("Any",{}, false)
    end
  end

  context "paid?" do
    should "know if a account has lapsed payment" do
      purchaser = Factory(:user)
      Factory(:paid_payment, :purchaser => purchaser).update_attribute(:paid_until, 1.day.ago)
      character = Factory(:user_character, :subscriber => purchaser).character
      assert_false character.paid?
    end

    should "know if a account is activily paying" do
      purchaser = Factory(:user)
      Factory(:paid_payment, :purchaser => purchaser)
      character = Factory(:user_character, :subscriber => purchaser).character
      assert character.paid?
    end

    should "know if a account is not activily paying" do
      purchaser = Factory(:user)
      Factory(:considering_payment, :purchaser => purchaser)
      character = Factory(:user_character, :subscriber => purchaser).character
      assert_false character.paid?
    end

  end
  
  context "state transitions" do
    should "refresh again if being refreshed was first set more then 10 minutes ago" do
      freeze_time
      character = Factory(:character)
      character.refreshing!
      freeze_time(11.minutes.from_now)
      assert_difference "Resque.size('find_upgrades_jobs')" do
        character.refresh_in_background!
      end
    end

    should "refresh if not currently being refreshed" do
      character = Factory(:character)
      assert_difference "Resque.size('find_upgrades_jobs')" do
        character.refresh_in_background!
      end
    end

    should "not refresh again if being refreshed is less then 10 minutes ago" do
      freeze_time
      character = Factory(:character)
      character.refreshing!
      freeze_time(9.minutes.from_now)
      assert_no_difference "Resque.size('find_upgrades_jobs')" do
        character.refresh_in_background!
      end
    end
  end

end
