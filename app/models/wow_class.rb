class WowClass < ActiveRecord::Base
  has_many :characters
  serialize :stat_multipliers
  belongs_to :primary_armor_type, :class_name => "ArmorType"
  
  module WowClassConstants
    DeathKnight = {:name => "Death Knight", :primary_armor_type => ArmorType.find_or_create_by_name("Plate"),
      :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Druid = {:name => "Druid", :primary_armor_type => ArmorType.find_or_create_by_name("Leather"), :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Hunter = {:name => "Hunter", :primary_armor_type => ArmorType.find_or_create_by_name("Mail"), :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Mage = {:name => "Mage", :primary_armor_type => ArmorType.find_or_create_by_name("Cloth"), :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Paladin = {:name => "Paladin", :primary_armor_type => ArmorType.find_or_create_by_name("Plate"), :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Priest = {:name => "Priest", :primary_armor_type => ArmorType.find_or_create_by_name("Cloth"), :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Rogue = {:name => "Rogue", :primary_armor_type => ArmorType.find_or_create_by_name("Leather"), :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Shaman = {:name => "Shaman", :primary_armor_type => ArmorType.find_or_create_by_name("Mail"), :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Warlock = {:name => "Warlock", :primary_armor_type => ArmorType.find_or_create_by_name("Cloth"), :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Warrior = {:name => "Warrior", :primary_armor_type => ArmorType.find_or_create_by_name("Plate"), :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
  end
end
