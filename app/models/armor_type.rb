class ArmorType < ActiveRecord::Base
  has_many :wow_classes, :foreign_key => "primary_armor_type_id"
  has_many :items
  ARMOR = ["Plate", "Leather", "Mail", "Cloth"]
  ALL_SUPPORTED_ARMOR_TYPES = ARMOR + ["Miscellaneous", "Fist Weapon", "Sword", 
    "Axe", "Dagger", "Polearm", "Staff", "Bow", "Gun", "Crossbow", "Mace", "Thrown", "Wand", "Sigil", 
    "Totem", "Libram", "Idol"]
  
  class << self
    ALL_SUPPORTED_ARMOR_TYPES.each do |armor_type|
      define_method(armor_type.gsub(/\s/, '').underscore) do
        ArmorType.find_or_create_by_name(armor_type)
      end
    end
  end
  
  def should_be_shown?
    self.name != "Miscellaneous"
  end
  
  def is_armor?
    ARMOR.include?(self.name)
  end
end
