class Character < ActiveRecord::Base
  belongs_to :wow_class
  has_many :character_items
  has_many :equipped_items, :through => :character_items, :source => :item

  def top_3_frost_upgrades
    top_3_upgrades_for(Item.from_emblem_of_frost)
  end
  
  def top_3_triumph_upgrades
    top_3_upgrades_for(Item.from_emblem_of_triumph)
  end
  
  def top_3_upgrades_for(potential_upgrades)
    upgrades = potential_upgrades.select do |potential_upgrade|
      potential_upgrade.dps_compared_to(equipped_items.with_same_inventory_type(potential_upgrade).first) > 0
    end
    upgrades.sort_by do |upgrade|
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
