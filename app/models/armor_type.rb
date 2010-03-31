class ArmorType < ActiveRecord::Base
  has_many :wow_classes, :foreign_key => "primary_armor_type_id"
  has_many :items
  ALL_SUPPORTED_ARMOR_TYPES = ["Plate", "Leather", "Mail", "Cloth", "Miscellaneous", "Fist Weapon", "Sword", 
    "Axe", "Dagger", "Polearm", "Staff", "Bow", "Gun", "Crossbow", "Mace", "Thrown", "Wand", "Sigil", 
    "Totem", "Libram", "Idol"]
  
  class << self
    ALL_SUPPORTED_ARMOR_TYPES.each do |armor_type|
      define_method(armor_type.gsub(/\s/, '').underscore) do
        ArmorType.find_or_create_by_name(armor_type)
      end
    end
  end
end
