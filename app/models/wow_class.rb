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
        {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}
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
        {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}
      end
    end
    module Paladin
      def self.stat_multipliers(primary_spec)
        {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}
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

