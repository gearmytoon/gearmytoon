class WowClass < ActiveRecord::Base
  CLASS_NAMES = {"Death Knight" => {:primary_armor_type => ArmorType.Plate},
                 "Druid" => {:primary_armor_type => ArmorType.Leather}, 
                 "Hunter" => {:primary_armor_type => ArmorType.Mail}, 
                 "Mage" => {:primary_armor_type => ArmorType.Cloth}, 
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
        case primary_spec
        when "Frost"
          {:melee_dps => 337, :hit => 100, :strength => 97, :expertise => 81, :armor_penetration => 61, :crit => 45, :attack_power => 35, :haste => 28, :armor => 1}
        when "Unholy"
          {:melee_dps => 209, :strength => 100, :hit => 66, :expertise => 51, :haste => 48, :crit => 45, :attack_power => 34, :armor_penetration => 32, :armor => 1}
        else #Blood
          {:melee_dps => 360, :armor_penetration => 100, :strength => 99, :hit => 91, :expertise => 90, :crit => 57, :haste => 55, :attack_power => 36, :armor => 1}
        end
      end
    end
    
    module Druid
      def self.stat_multipliers(primary_spec)
        case primary_spec
        when "Balance"
          {:hit => 100, :spell_power => 66, :haste => 54, :crit => 43, :spirit => 22, :intellect => 22}
        when "Restoration"
          {:spell_power => 100, :mana_regen => 73, :haste => 57, :intellect => 51, :spirit => 32, :crit => 11}
        else #Feral Combat - dps
          {:agility => 100, :armor_penetration => 90, :strength => 80, :crit => 55, :expertise => 50, :hit => 50, :feral_attack_power => 40, :attack_power => 40, :haste => 35}
        end
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
        else #assume  
          {:melee_dps => 470, :hit => 100, :strength => 80, :expertise => 66, :crit => 40, :attack_power => 34, :agility => 32, :haste => 30, :armor_penetration => 22, :spell_power => 9}
        end
      end
    end
    
    module Priest
      def self.stat_multipliers(primary_spec)
        case primary_spec
        when "Holy"
          {:mana_regen => 100, :intellect => 69, :spell_power => 60, :spirit => 52, :crit => 38, :haste => 31}
        when "Shadow"
          {:hit => 100, :spell_power => 76, :crit => 54, :haste => 50, :spirit => 16, :intellect => 16}
        else #Discipline
          {:spell_power => 100, :mana_regen => 67, :intellect => 65, :haste => 59, :crit => 48, :spirit => 22}
        end
      end
    end

    module Shaman
      def self.stat_multipliers(primary_spec)
        case primary_spec
        when "Enhancement"
          {:melee_dps => 135, :hit => 100, :expertise => 84, :agility => 55, :intellect => 55, :crit => 55, :haste => 42, :strength => 35, :attack_power => 32, :spell_power => 29, :armor_penetration => 26}
        when "Restoration"
          {:mana_regen => 100, :intellect => 85, :spell_power => 77, :crit => 62, :haste => 35}
        else #Elemental
          {:hit => 100, :spell_power => 60, :haste => 56, :crit => 40, :intellect => 11}
        end
      end
    end

    module Warlock
      def self.stat_multipliers(primary_spec)
        case primary_spec
        when "Destruction"
          {:hit => 100, :spell_power => 47, :haste => 46, :spirit => 26, :crit => 16, :intellect => 13}
        when "Demonology"
          {:hit => 100, :haste => 50, :spell_power => 45, :crit => 31, :spirit => 29, :intellect => 13}
        else #Affliction
          {:hit => 100, :spell_power => 72, :haste => 61, :crit => 38, :spirit => 34, :intellect => 15}
        end
      end
    end

    module Warrior
      def self.stat_multipliers(primary_spec)
        case primary_spec
        when "Protection"
          {:stamina => 100, :dodge => 90, :defense => 86, :block_value => 81, :agility => 67, :parry => 67, :block => 48, :strength => 48, :expertise => 19, :hit => 10, :armor_penetration => 10, :crit => 7, :armor => 6, :haste => 1, :attack_power => 1}
        else #fury and arms
          {:expertise => 100, :strength => 82, :crit => 66, :agility => 53, :armor_penetration => 52, :hit => 48, :haste => 36, :attack_power => 31, :armor => 5}
        end
      end
    end
  end
  
end

