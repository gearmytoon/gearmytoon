class Item < ActiveRecord::Base
  TRIUMPH_EMBLEM_ARMORY_ID = 47241
  FROST_EMBLEM_ARMORY_ID = 49426

  serialize :bonuses
  named_scope :from_emblem_of_triumph, :conditions => {:source_wowarmory_item_id => TRIUMPH_EMBLEM_ARMORY_ID}
  named_scope :from_emblem_of_frost, :conditions => {:source_wowarmory_item_id => FROST_EMBLEM_ARMORY_ID}
  named_scope :from_heroic_dungeon, Proc.new {{:conditions => {:source_area_id => Area.dungeons.map(&:id)}}} #delaying evaluation
  named_scope :with_same_inventory_type, Proc.new { |item|
    ranged_weapon_inventory_types = [15,25,26]
    if ranged_weapon_inventory_types.include?(item.inventory_type)
      {:conditions => {:inventory_type => ranged_weapon_inventory_types}}
    else
      {:conditions => {:inventory_type => item.inventory_type}}
    end
  }

  named_scope :usable_by, Proc.new {|wow_class| {:conditions => {:armor_type_id => [ArmorType.Miscellaneous.id, wow_class.primary_armor_type.id]}}}
  belongs_to :armor_type
  belongs_to :source_area, :class_name => "Area"

  def self.badge_of_frost
    fetch_from_api(FROST_EMBLEM_ARMORY_ID)
  end

  def self.badge_of_triumph
    fetch_from_api(TRIUMPH_EMBLEM_ARMORY_ID)
  end

  def self.fetch_from_api(item_id)
    api = Wowr::API.new
    item = api.get_item(item_id)
  end

  def item_id #to quack the same as wowr wowitems
    wowarmory_item_id
  end

  def dps_compared_to_for_character(item, character)
    return character.dps_for(self.bonuses) if item.nil?
    character.dps_for(self.bonuses) - character.dps_for(item.bonuses)
  end

end

class WowHelpers
  QUALITY_ADJECTIVE_LOOKUP = {0 => "poor", 1 => "common", 2 => "uncommon", 3 => "rare", 4 => "epic", 5 => "legendary", 6 => "artifact", 7 => "heirloom"}
  def self.quality_adjective_for(item)
    QUALITY_ADJECTIVE_LOOKUP[item.quality]
  end
end
