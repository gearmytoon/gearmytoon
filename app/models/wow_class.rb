class WowClass < ActiveRecord::Base
  has_many :characters
  serialize :stat_multipliers
  belongs_to :primary_armor_type, :class_name => "ArmorType"
  
  def equippable_items
    Item.usable_by(self)
  end
  
  module WowClassConstants
    DeathKnight = {:name => "Death Knight", :primary_armor_type => ArmorType.Plate,
      :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Druid = {:name => "Druid", :primary_armor_type => ArmorType.Leather, :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Hunter = {:name => "Hunter", :primary_armor_type => ArmorType.Mail, :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Mage = {:name => "Mage", :primary_armor_type => ArmorType.Cloth, :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Paladin = {:name => "Paladin", :primary_armor_type => ArmorType.Plate, :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Priest = {:name => "Priest", :primary_armor_type => ArmorType.Cloth, :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Rogue = {:name => "Rogue", :primary_armor_type => ArmorType.Leather, :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Shaman = {:name => "Shaman", :primary_armor_type => ArmorType.Mail, :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Warlock = {:name => "Warlock", :primary_armor_type => ArmorType.Cloth, :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
    Warrior = {:name => "Warrior", :primary_armor_type => ArmorType.Plate, :stat_multipliers => {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}}
  end
end
