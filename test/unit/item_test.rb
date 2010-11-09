require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase
  context "icon" do
    should "return a 43x43 image URL as the default" do
      icon = "inv_belt_60"
      icon_url = "http://wowarmory.com/wow-icons/_images/43x43/inv_belt_60.png"
      item = Factory(:item, :icon => icon)
      assert_equal icon_url, item.icon
    end

    should "return a 21x21 image URL" do
      icon = "inv_belt_60"
      icon_url = "http://wowarmory.com/wow-icons/_images/21x21/inv_belt_60.png"
      item = Factory(:item, :icon => icon)
      assert_equal icon_url, item.icon(:small)
    end

    should "return a 64x64 image URL" do
      icon = "inv_belt_60"
      large_icon_url = "http://wowarmory.com/wow-icons/_images/64x64/inv_belt_60.jpg"
      item = Factory(:item, :icon => icon)
      assert_equal large_icon_url, item.icon(:large)
    end
  end

  context "slot_info" do
    should "show with armor type name if it is armor" do
      item = Factory(:item, :armor_type => ArmorType.cloth, :slot => "Helm")
      assert_equal "Cloth Helm", item.slot_info
    end
    should "not error out if there is no armor type" do
      item = Factory(:item, :armor_type => nil, :slot => "Helm")
      assert_equal "Helm", item.slot_info
    end
    should "not show with armor type name if it is not armor" do
      item = Factory(:item, :armor_type => ArmorType.crossbow, :slot => "Ranged")
      assert_equal "Ranged", item.slot_info
    end
  end

  context "equipped_stats" do
    should "exclude weapon stats" do
      weapon_stats = {:melee_attack_speed => 1, :melee_min_damage => 1, :melee_max_damage => 1, :melee_dps => 1,
                      :ranged_attack_speed => 1, :ranged_min_damage => 1, :ranged_max_damage => 1, :ranged_dps => 1}
      item = Factory(:item, :bonuses => weapon_stats)
      assert_equal({}, item.equipped_stats)
    end

    should "exclude armor" do
      armor = {:armor => 1}
      item = Factory(:item, :bonuses => armor)
      assert_equal({}, item.equipped_stats)
    end

    should "include resilience" do
      resilience = {:resilience => 1}
      item = Factory(:item, :bonuses => resilience)
      assert_equal({:resilience => 1}, item.equipped_stats)
    end

    should "exclude base_stats" do
      base_stats = {:spirit => 1, :stamina => 1, :intellect => 1, :strength => 1, :agility => 1}
      item = Factory(:item, :bonuses => base_stats)
      assert_equal({}, item.equipped_stats)
    end

    should "include equipped stats" do
      expected = {:crit => 1, :attack_power => 1, :armor_penetration => 1, :haste => 1, :hit => 1, :spell_power => 1, 
                  :expertise => 1, :mana_regen => 1, :dodge => 1, :defense => 1, :parry => 1, :block => 1}
      item = Factory(:item, :bonuses => expected)
      assert_equal expected, item.equipped_stats
    end
  end

  context "base_stats" do
    should "slice out the basic stats" do
      expected = {:spirit => 1, :stamina => 1, :intellect => 1, :strength => 1, :agility => 1}
      item = Factory(:item, :bonuses => expected)
      assert_equal expected, item.base_stats
    end
    should "slice out other stats" do
      other_stats = {:crit => 1, :hit => 1, :expertise => 1, :spell_power => 1, :attack_power => 1}
      item = Factory(:item, :bonuses => other_stats)
      assert_equal({}, item.base_stats)
    end
  end

  should "show ranged weapon info" do
    item = Factory(:ranged_weapon, :bonuses => {:ranged_attack_speed => 3.5, :ranged_min_damage => 200, :ranged_max_damage => 300, :ranged_dps => 100.0})
    assert_equal "200-300 Dmg", item.damage_range
  end

  context "usable_in_same_slot_as" do
    should "find all items in the same slot" do
      item = Factory(:item, :slot => "Head")
      Factory(:item, :slot => "Wrist")
      assert_equal [item], Item.usable_in_same_slot_as(item)
    end
  end

  context "usable_by" do
    should "know that a rogue cannot use staffs" do
      rogue = Factory(:a_rogue)
      mace = Factory(:item, :slot => "Main Hand", :armor_type => ArmorType.mace)
      staff = Factory(:item, :slot => "Two-Hand", :armor_type => ArmorType.staff)
      assert_equal [mace], Item.usable_by(rogue.wow_class)
    end

    should "not find common, rare or uncommon items as upgrades" do
      hunter = Factory(:a_hunter)
      Factory(:item, :quality => "common")
      Factory(:item, :quality => "uncommon")
      Factory(:item, :quality => "rare")
      epic = Factory(:item, :quality => "epic")
      assert_equal [epic], Item.usable_by(hunter.wow_class)
    end

    should "know that a rogue cannot use maces" do
      hunter = Factory(:a_hunter)
      mace = Factory(:item, :slot => "Main Hand", :armor_type => ArmorType.mace)
      staff = Factory(:item, :slot => "Two-Hand", :armor_type => ArmorType.staff)
      assert_equal [staff], Item.usable_by(hunter.wow_class)
    end

    should_eventually "know thata rogue cannot use 2h maces" do
      rogue = Factory(:a_rogue)
      mace = Factory(:item, :slot => "Main Hand", :armor_type => ArmorType.mace)
      two_handed_mace = Factory(:item, :slot => "Two-Hand", :armor_type => ArmorType.mace)
      assert_equal [mace], Item.usable_by(rogue.wow_class)
    end

  end

  context "gems" do
    should "only find gems" do
      gem_item = Factory(:gem)
      Factory(:item)
      assert_equal [gem_item], GemItem.all
    end
  end
  
  context "summarize" do
    setup do
      Spec.destroy_all
    end
    should "generate a items summary for the percent of toons who use the item" do
      item = Factory(:item)
      hunter = Factory(:a_hunter)
      shaman = Factory(:a_shaman)
      hunter.gmt_score = 2500
      hunter.send(:update_without_callbacks)
      shaman.gmt_score = 3500
      shaman.send(:update_without_callbacks)
      Factory(:character_item, :character => hunter, :item => item)
      Factory(:character_item, :character => shaman, :item => item)
      assert_difference "ItemPopularity.count", 2 do
        item.summarize
      end
      hunter_ip = ItemPopularity.first(:conditions => {:spec_id => hunter.spec_id})
      shaman_ip = ItemPopularity.first(:conditions => {:spec_id => shaman.spec_id})
      assert_equal item, hunter_ip.item
      assert_equal item, shaman_ip.item
      assert_equal 50, hunter_ip.percentage
      assert_equal 50, shaman_ip.percentage
      assert_equal 2500, hunter_ip.average_gmt_score
      assert_equal 3500, shaman_ip.average_gmt_score
    end

    should "not generate duplicate item popularties" do
      item = Factory(:item)
      hunter = Factory(:a_hunter)
      Factory(:character_item, :character => hunter, :item => item)
      assert_difference "ItemPopularity.count", 1 do
        item.summarize
      end
      assert_no_difference "ItemPopularity.count" do
        item.summarize
      end
    end

    should "generate a items average gmt score summary" do
      item = Factory(:item)
      hunter_spec = Factory(:spec)
      hunter1 = Factory(:a_hunter, :spec => hunter_spec)
      hunter1.gmt_score = 2500
      hunter1.send(:update_without_callbacks)
      hunter2 = Factory(:a_hunter, :spec => hunter_spec)
      hunter2.gmt_score = 3500
      hunter2.send(:update_without_callbacks)
      Factory(:character_item, :character => hunter1, :item => item)
      Factory(:character_item, :character => hunter2, :item => item)
      assert_difference "ItemPopularity.count" do
        item.summarize
      end
      hunter_ip = ItemPopularity.first(:conditions => {:spec_id => hunter1.spec_id})
      assert_equal 3000, hunter_ip.average_gmt_score
    end

    should "only generate summaries for real specs" do
      item = Factory(:item)
      no_spec = Factory(:spec, :name => "")
      hunter = Factory(:character, :spec => no_spec)
      Factory(:character_item, :character => hunter, :item => item)
      assert_no_difference "ItemPopularity.count" do
        item.summarize
      end
    end

    should "not generate summaries if the item is not used" do
      item = Factory(:item)
      hunter = Factory(:character)
      assert_no_difference "ItemPopularity.count" do
        item.summarize
      end
    end
  end
  
  context "popularity_params" do
    should "generate popularity params" do
      item = Factory(:item)
      2.times {Factory(:item_popularity, :spec => Factory(:spec), :item => item)}
      assert_equal 2, item.popularity_params.size
    end
  end

end
