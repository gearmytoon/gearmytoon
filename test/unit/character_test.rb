require File.dirname(__FILE__) + '/../test_helper'

class CharacterTest < ActiveSupport::TestCase
  context "associations" do
    should "serialize total_item_bonuses" do
      character = Factory(:character, :total_item_bonuses => {:hit => 25})
      assert_equal({:hit => 25}, character.reload.total_item_bonuses)
    end
    should_have_many :equipped_items
    should_have_many :character_items
    should_belong_to :wow_class
    should_belong_to :user
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

    should "set the locale to 'us' if not present" do
      c = Character.new
      c.valid?
      assert_equal 'us', c.locale
    end
  end

  context "top_3_frost_upgrades" do

    should "not find empty slot upgrades if the toon has a two handed weapon" do
      character = Factory(:a_hunter)
      Factory(:character_item, :character => character, :item => Factory(:polearm))
      Factory(:fist_from_emblem_of_frost)
      assert_equal [], character.frost_upgrades
    end

    should "find two upgrades for both rings" do
      character = Factory(:a_hunter)
      no_dps_ring = Factory(:ring_from_frost_emblem, :bonuses => {:attack_power => 0.0})
      Factory(:character_item, :character => character, :item => no_dps_ring)
      Factory(:character_item, :character => character, :item => no_dps_ring)
      new_dps_ring = Factory(:ring_from_frost_emblem, :bonuses => {:attack_power => 500.0})
      assert_equal 2, character.frost_upgrades.length
      assert_equal no_dps_ring, character.frost_upgrades.first.old_item
      assert_equal new_dps_ring, character.frost_upgrades.first.new_item
    end

    should "find upgrades of the same armor type" do
      rogue = Factory(:character_item, :character => Factory(:a_rogue)).character
      plate_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :armor_type => ArmorType.plate)
      leather_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :armor_type => ArmorType.leather)
      assert_equal 1, rogue.top_3_frost_upgrades.size
      assert_equal leather_upgrade, rogue.top_3_frost_upgrades.first.new_item
    end

    should "find a upgrade if you do not have a inventory item in that slot" do
      character = Factory(:character_item).character
      upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0})
      assert_equal upgrade, character.top_3_frost_upgrades.first.new_item
    end

    should "order the upgrades by the dps increase" do
      character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
      mid_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 200.0})
      upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0})
      upgrades = [upgrade, mid_upgrade]
      assert_equal upgrades.map(&:id), character.top_3_frost_upgrades.map(&:new_item).map(&:id)
    end

    should "find a characters upgrades from frost badges" do
      character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
      Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 50.0})
      upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0})
      assert_equal 1, character.top_3_frost_upgrades.length
      assert_equal upgrade, character.top_3_frost_upgrades.first.new_item
    end

    should "find the first 3 upgrades" do
      character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
      4.times { Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}) }
      assert_equal 3, character.top_3_frost_upgrades.length
    end
  end

  context "top_3_triumph_upgrades" do

    should "find upgrades of the Miscellaneous armor type for any character" do
      rogue = Factory(:character_item, :character => Factory(:a_rogue)).character
      leather_upgrade = Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 500.0}, :armor_type => ArmorType.miscellaneous)
      assert_equal 1, rogue.top_3_triumph_upgrades.size
      assert_equal leather_upgrade, rogue.top_3_triumph_upgrades.first.new_item
    end

    should "find upgrades of the same armor type" do
      rogue = Factory(:character_item, :character => Factory(:a_rogue)).character
      plate_upgrade = Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 500.0}, :armor_type => ArmorType.plate)
      leather_upgrade = Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 500.0}, :armor_type => ArmorType.leather)
      assert_equal 1, rogue.top_3_triumph_upgrades.size
      assert_equal leather_upgrade, rogue.top_3_triumph_upgrades.first.new_item
    end

    should "order the upgrades by the dps increase" do
      character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
      mid_upgrade = Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 200.0})
      upgrade = Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 500.0})
      upgrades = [upgrade, mid_upgrade]
      assert_equal upgrades.map(&:id), character.top_3_triumph_upgrades.map(&:new_item).map(&:id)
    end

    should "find a characters upgrades from frost badges" do
      character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
      Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 50.0})
      upgrade = Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 500.0})
      assert_equal 1, character.top_3_triumph_upgrades.length
      assert_equal upgrade, character.top_3_triumph_upgrades.first.new_item
    end

    should "find the first 3 upgrades" do
      character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
      4.times { Factory(:item_from_emblem_of_triumph, :bonuses => {:attack_power => 500.0}) }
      assert_equal 3, character.top_3_triumph_upgrades.length
    end
  end

  context "top_3_heroic_dungeon_upgrades" do
    should "return three upgrades" do
      character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
      4.times { Factory(:item_from_heroic_dungeon, :bonuses => {:attack_power => 500.0}) }
      upgrades = character.top_3_heroic_dungeon_upgrades
      assert_equal 3, upgrades.size
      upgrades.each do |upgrade|
        assert_kind_of Upgrade, upgrade
      end
    end

    should "only find items from heroic dungeons" do
      character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
      heroic_upgrade = Factory(:item_from_heroic_dungeon, :bonuses => {:attack_power => 500.0})
      Factory(:item_from_emblem_of_triumph)
      upgrades = character.top_3_heroic_dungeon_upgrades
      assert_equal 1, upgrades.size
      assert_equal heroic_upgrade, upgrades.first.new_item
    end

  end
  context "top_3_raid_upgrades" do
    should "return three upgrades" do
      character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
      4.times { Factory(:item_from_heroic_raid, :bonuses => {:attack_power => 500.0}) }
      upgrades = character.top_3_raid_upgrades
      assert_equal 3, upgrades.size
      upgrades.each do |upgrade|
        assert_kind_of Upgrade, upgrade
      end
    end

    should "only find items from raids" do
      character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
      heroic_upgrade = Factory(:item_from_heroic_raid, :bonuses => {:attack_power => 500.0})
      Factory(:item_from_heroic_dungeon)
      upgrades = character.top_3_raid_upgrades
      assert_equal 1, upgrades.size
      assert_equal heroic_upgrade, upgrades.first.new_item
    end

  end
  context "top_3_honor_upgrades" do
    should "find top 3" do
      character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
      4.times{Factory(:item_from_honor_points)}
      upgrades = character.top_3_honor_point_upgrades
      assert_equal 3, upgrades.size
    end

    should "only find items from honor points" do
      character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
      honor_item = Factory(:item_from_honor_points)
      Factory(:item_from_emblem_of_triumph)
      upgrades = character.top_3_honor_point_upgrades
      assert_equal 1, upgrades.size
      assert_equal honor_item, upgrades.first.new_item
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

  context "stat_change_between" do
    should "know the change in stats between two items" do
      character = Factory(:character)
      expected_result = {:agility => 10.0, :attack_power => -10.0}
      old_item = Factory(:item, :bonuses => {:agility => 10.0, :attack_power => 20.0})
      new_item = Factory(:item, :bonuses => {:agility => 20.0, :attack_power => 10.0})
      assert_equal expected_result, character.stat_change_between(new_item, old_item)
    end

    should "know the change in stats between two items after the hit cap" do
      character = Factory(:character, :total_item_bonuses => {:hit => 251})
      expected_result = {:hit => 12.0, :agility=>0.0, :attack_power => -10.0}
      old_item = Factory(:item, :bonuses => {:agility => 10.0, :hit => 251, :attack_power => 20.0})
      new_item = Factory(:item, :bonuses => {:agility => 10.0, :hit => 300, :attack_power => 10.0})
      assert_equal expected_result, character.stat_change_between(new_item, old_item)
    end

    should "know the change in stats between two items after the hit cap when the character is way above the hit cap" do
      character = Factory(:character, :total_item_bonuses => {:hit => 300})
      expected_result = {:hit => 0.0, :agility=>0.0, :attack_power => -10.0}
      old_item = Factory(:item, :bonuses => {:agility => 10.0, :hit => 22, :attack_power => 20.0})
      new_item = Factory(:item, :bonuses => {:agility => 10.0, :hit => 0, :attack_power => 10.0})
      assert_equal expected_result, character.stat_change_between(new_item, old_item)
    end

    should "be okay if the total hit can't be imported for a character" do
      character = Factory(:character, :total_item_bonuses => {})
      expected_result = {:hit => -22.0, :agility=>0.0, :attack_power => -10.0}
      old_item = Factory(:item, :bonuses => {:agility => 10.0, :hit => 22, :attack_power => 20.0})
      new_item = Factory(:item, :bonuses => {:agility => 10.0, :hit => 0, :attack_power => 10.0})
      assert_equal expected_result, character.stat_change_between(new_item, old_item)
    end

  end

  context "hard_cap" do
    should "be 263 for hit for hunters" do
      character = Factory(:a_hunter)
      assert_equal 263, character.hard_caps[:hit]
    end

    should "be 886 for hit for hunters" do
      character = Factory(:a_rogue)
      assert_equal 886, character.hard_caps[:hit]
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
end
