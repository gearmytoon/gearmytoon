require File.dirname(__FILE__) + '/../test_helper'

class WowClassTest < ActiveSupport::TestCase
  context "associations" do
    should_belong_to :primary_armor_type
    should "get stat_multipliers based on class_name" do
      wow_class = WowClass.create_class!("Rogue")
      assert_equal WowClass::WowClassConstants::Rogue.stat_multipliers("Combat"), wow_class.reload.stat_multipliers("Combat")
    end
  end

  context "stat_multipliers" do
    should "be based on a character spec" do
      wow_class = WowClass.create_class!("Hunter")
      assert_not_equal wow_class.stat_multipliers("Survival"), wow_class.stat_multipliers("Marksmanship")
      assert_not_equal wow_class.stat_multipliers("Survival"), wow_class.stat_multipliers("Beast Mastery")
      assert_not_equal wow_class.stat_multipliers("Marksmanship"), wow_class.stat_multipliers("Beast Mastery")
    end
    should "default to marksmanship for hunters who do not have a primary spec" do
      wow_class = WowClass.create_class!("Hunter")
      assert_equal wow_class.stat_multipliers("NONE"), wow_class.stat_multipliers("Marksmanship")
    end
  end

  context "equippable_items" do
    should "find upgrades of the same armor type" do
      rogue = WowClass.create_class!("Rogue")
      plate_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :armor_type => ArmorType.Plate)
      leather_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :armor_type => ArmorType.Leather)
      assert_equal 1, rogue.equippable_items.size
      assert_equal leather_upgrade, rogue.equippable_items.first
    end
  end
  
  {:DeathKnight => ["Blood", "Frost", "Unholy"],
   :Druid => ["Balance", "Feral Combat", "Restoration"],
   :Hunter => ["Beast Mastery", "Marksmanship", "Survival"],
   :Mage => ["Frost", "Fire", "Arcane"],
   :Paladin => ["Protection", "Holy", "Retribution"],
   :Priest => ["Holy", "Shadow", "Discipline"],
   :Rogue => ["Assassination", "Combat", "Subtlety"],
   :Shaman => ["Elemental", "Enhancement", "Restoration"],
   :Warlock => ["Demonology", "Destruction", "Affliction"],
   :Warrior => ["Arms", "Fury", "Protection"]}.each do |wow_class, possible_specs|
    context "WowClassConstants" do
      
      should "#{wow_class} have hard_caps" do
        assert_not_nil "WowClass::WowClassConstants::#{wow_class.to_s}".constantize.hard_caps
      end
      
      (possible_specs << "Hybrid").each do |possible_spec|
        should "#{wow_class} #{possible_spec} have valid multipliers" do
          valid_multipliers = [:agility, :strength, :expertise, :intellect, :attack_power, 
                              :melee_dps, :haste, :hit, :crit, :armor_penetration, :armor,
                              :spirit, :spell_power, :dodge, :parry, :mana_regen,
                              :block_value, :defense, :stamina, :block,
                              :ranged_max_damage, :ranged_attack_speed, :ranged_min_damage, 
                              :feral_attack_power]
          actual_multipliers = "WowClass::WowClassConstants::#{wow_class.to_s}".constantize.stat_multipliers(possible_spec)
          unknown_multipliers = actual_multipliers.keys - valid_multipliers
          assert unknown_multipliers.empty?, "For class #{wow_class} found invalid multipliers #{unknown_multipliers.join(",")}"
        end
      end
    end
  end
end
