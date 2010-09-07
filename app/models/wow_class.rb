class WowClass < ActiveRecord::Base
  CLASS_NAMES = {"Death Knight" => {:primary_armor_type => ArmorType.plate},
                 "Druid" => {:primary_armor_type => ArmorType.leather},
                 "Hunter" => {:primary_armor_type => ArmorType.mail},
                 "Mage" => {:primary_armor_type => ArmorType.cloth},
                 "Paladin" => {:primary_armor_type => ArmorType.plate},
                 "Priest" => {:primary_armor_type => ArmorType.cloth},
                 "Rogue" => {:primary_armor_type => ArmorType.leather},
                 "Shaman" => {:primary_armor_type => ArmorType.mail},
                 "Warlock" => {:primary_armor_type => ArmorType.cloth},
                 "Warrior" => {:primary_armor_type => ArmorType.plate}}
  has_many :characters
  belongs_to :primary_armor_type, :class_name => "ArmorType"

  def equippable_items
    Item.usable_by(self)
  end

  def usable_armor_types
    armor_types + [primary_armor_type, ArmorType.miscellaneous]
  end

  def self.create_all_classes!
    CLASS_NAMES.keys.map do |class_name|
      create_class!(class_name)
    end
  end

  def self.create_class!(class_name)
    class_name.gsub(/\s/,"").constantize.create!({:name => class_name}.merge(CLASS_NAMES[class_name]))
  end

  def stat_multipliers(primary_spec, point_distribution, for_pvp)
    class_multipliers = class_specific_multipliers(primary_spec, point_distribution, for_pvp)
    for_pvp ? class_multipliers.merge(:resilience => 80, :stamina => 80) : class_multipliers
  end

  def css_name
    self.name.gsub(/\s/, "").underscore
  end
end
