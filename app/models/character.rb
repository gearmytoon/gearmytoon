class Character < ActiveRecord::Base
  belongs_to :wow_class
  has_many :character_items
  has_many :equipped_items, :through => :character_items, :source => :item

  def top_3_frost_upgrades
    upgrades = Item.from_emblem_of_frost.select do |emblem_of_frost_item|
      emblem_of_frost_item.dps_compared_to(equipped_items.with_same_inventory_type(emblem_of_frost_item).first) > 0
    end
    upgrades = upgrades.sort_by do |upgrade|
      upgrade.dps_compared_to(equipped_items.with_same_inventory_type(upgrade).first)
    end.reverse.slice(0, 3)
  end
  
  def top_3_triumph_upgrades
    upgrades = Item.from_emblem_of_triumph.select do |emblem_of_triumph_item|
      emblem_of_triumph_item.dps_compared_to(equipped_items.with_same_inventory_type(emblem_of_triumph_item).first) > 0
    end
    upgrades = upgrades.sort_by do |upgrade|
      upgrade.dps_compared_to(equipped_items.with_same_inventory_type(upgrade).first)
    end.reverse.slice(0, 3)
  end
  
  def wow_class_name
    wow_class.name
  end
  
  def self.find_by_name_or_create_from_wowarmory(name)
    character = Character.find_by_name(name)
    if character
      return character
    else
      CharacterImporter.import_character_and_all_items(name, "Baelgun") #TODO LOOKUP BY REALM AND REGION!
    end
  end
end
