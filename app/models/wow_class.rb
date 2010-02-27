class WowClass < ActiveRecord::Base
  has_many :characters
  serialize :stat_multipliers
  
  module WowClassConstants
    DeathKnight = {:name => "Death Knight", :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Druid = {:name => "Druid", :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Hunter = {:name => "Hunter", :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Mage = {:name => "Mage", :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Paladin = {:name => "Paladin", :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Priest = {:name => "Priest", :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Rogue = {:name => "Rogue", :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Shaman = {:name => "Shaman", :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Warlock = {:name => "Warlock", :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Warrior = {:name => "Warrior", :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
  end
end
