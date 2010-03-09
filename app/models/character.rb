class Character < ActiveRecord::Base
  belongs_to :wow_class
  has_many :character_items
  has_many :equipped_items, :through => :character_items, :source => :item

  def top_3_frost_upgrades
    top_3_upgrades_for(wow_class.equippable_items.from_emblem_of_frost)
  end

  def top_3_triumph_upgrades
    top_3_upgrades_for(wow_class.equippable_items.from_emblem_of_triumph)
  end

  def top_3_heroic_dungeon_upgrades
    top_3_upgrades_for(wow_class.equippable_items.from_heroic_dungeon)
  end

  def top_3_upgrades_for(potential_upgrades)
    upgrades = potential_upgrades.inject([]) do |found_upgrades, potential_upgrade|
      equipped_item = equipped_items.with_same_inventory_type(potential_upgrade).first
      if potential_upgrade.dps_compared_to_for_class(equipped_item, wow_class) > 0
        found_upgrades << Upgrade.new(wow_class, potential_upgrade, equipped_item)
      else
        found_upgrades
      end
    end
    upgrades.sort_by(&:dps_change).reverse.slice(0, 3)
  end

  def wow_class_name
    wow_class.name
  end

  def dps_for(item)
    wow_class.dps_for(item)
  end

  def self.find_by_name_and_realm_or_create_from_wowarmory(name, realm)
    character = Character.find_by_name_and_realm(name, realm)
    if character
      return character
    else
      CharacterImporter.import_character_and_all_items(name, realm) #TODO LOOKUP BY REALM AND REGION!
    end
  end
end
