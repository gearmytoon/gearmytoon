class WowClass < ActiveRecord::Base
  CLASS_NAMES = {"Death Knight" => {:primary_armor_type => ArmorType.Plate},
                 "Druid" => {:primary_armor_type => ArmorType.Leather}, 
                 "Hunter" => {:primary_armor_type => ArmorType.Mail}, 
                 "Paladin" => {:primary_armor_type => ArmorType.Plate}, 
                 "Priest" => {:primary_armor_type => ArmorType.Cloth}, 
                 "Rogue" => {:primary_armor_type => ArmorType.Leather}, 
                 "Shaman" => {:primary_armor_type => ArmorType.Mail}, 
                 "Warlock" => {:primary_armor_type => ArmorType.Cloth}, 
                 "Warrior" => {:primary_armor_type => ArmorType.Plate}}
  has_many :characters
  belongs_to :primary_armor_type, :class_name => "ArmorType"
  
  def equippable_items
    Item.usable_by(self)
  end
  
  def stat_multipliers(primary_spec)
    "WowClass::WowClassConstants::#{self.name.gsub(/\s/,"")}".constantize.stat_multipliers(primary_spec)
  end
  
  def self.create_all_classes!
    CLASS_NAMES.keys.map do |class_name|
      create_class!(class_name)
    end
  end
  
  def self.create_class!(class_name)
    WowClass.create!({:name => class_name}.merge(CLASS_NAMES[class_name]))
  end
  
  module WowClassConstants
    module Rogue
      def self.stat_multipliers(primary_spec)
        case primary_spec
        when "Assassination"
          {:melee_dps => 170, :agility => 100, :expertise => 87, :hit => 83, :crit => 81, :attack_power => 65, :armor_penetration => 65, :haste => 64, :strength => 55}
        when "Combat"
          {:melee_dps => 220, :armor_penetration => 100, :agility => 100, :expertise => 82, :hit => 80, :crit => 75, :haste => 73, :strength => 55, :attack_power => 50}
        else # "Subtlety"
          {:melee_dps => 228, :expertise => 100, :agility => 100, :hit => 80, :armor_penetration => 75, :crit => 75, :haste => 75, :strength => 55, :attack_power => 50}
        end
      end
    end

    module Hunter
      def self.stat_multipliers(primary_spec)
        case primary_spec
        when "Survival"
          {:ranged_min_damage => 900, :ranged_max_damage => 910, :ranged_attack_speed => 50, :hit => 100, :agility => 76, :crit => 42, :intellect => 35, :haste => 31, :attack_power => 29, :armor_penetration => 26}
        when "Beast Mastery"
          {:ranged_min_damage => 900, :ranged_max_damage => 910, :ranged_attack_speed => 50, :hit => 100, :agility => 58, :crit => 40, :intellect => 37, :haste => 21, :attack_power => 30, :armor_penetration => 28}
        else #assume Marksmanship
          {:ranged_min_damage => 900, :ranged_max_damage => 910, :ranged_attack_speed => 50, :hit => 100, :agility => 74, :crit => 57, :intellect => 39, :haste => 24, :attack_power => 32, :armor_penetration => 40}
        end
      end
    end
    
    module DeathKnight
      def self.stat_multipliers(primary_spec)
        {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}
      end
    end
    module Druid
      def self.stat_multipliers(primary_spec)
        {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}
      end
    end
    module Mage
      def self.stat_multipliers(primary_spec)
        case primary_spec
        when "Arcane"
          {:hit => 100, :haste => 54, :spell_power => 49, :crit => 37, :intellect => 34, :spirit => 14}
        when "Frost"
          {:hit => 100, :haste => 42, :spell_power => 39, :crit => 19, :intellect => 6}
        else # Fire
          {:hit => 100, :haste => 53, :spell_power => 46, :crit => 43, :intellect => 13}
        end
      end
    end
    module Paladin
      def self.stat_multipliers(primary_spec)
        case primary_spec
        when "Protection"
          {:stamina => 100, :agility => 60, :expertise => 59, :dodge => 55, :defense => 45, :parry => 30, :strength => 16, :armor => 8, :block => 7, :block_value => 6}
        when "Holy"
          {:intellect => 100, :mana_regen => 88, :spell_power => 58, :crit => 46, :haste => 35}
        else #assume Retribution
          {:melee_dps => 470, :hit => 100, :strength => 80, :expertise => 66, :crit => 40, :attack_power => 34, :agility => 32, :haste => 30, :armor_penetration => 22, :spell_power => 9}
        end
      end
    end
    module Priest
      def self.stat_multipliers(primary_spec)
        {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}
      end
    end

    module Shaman
      def self.stat_multipliers(primary_spec)
        {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}
      end
    end

    module Warlock
      def self.stat_multipliers(primary_spec)
        {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}
      end
    end

    module Warrior
      def self.stat_multipliers(primary_spec)
        {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}
      end
    end
  end
  
end

