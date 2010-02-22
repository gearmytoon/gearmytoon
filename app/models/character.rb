class Character < ActiveRecord::Base
  belongs_to :wow_class
  has_many :character_items
  has_many :equipped_items, :through => :character_items, :source => :item

  def top_3_frost_upgrades
    Item.from_emblem_of_frost
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
