class Item < ActiveRecord::Base
  TRIUMPH_EMBLEM_ARMORY_ID = 47241
  FROST_EMBLEM_ARMORY_ID = 49426

  named_scope :from_emblem_of_triumph, :conditions => {:source_item_id => TRIUMPH_EMBLEM_ARMORY_ID}, :order => ['items.dps DESC']
  named_scope :from_emblem_of_frost, :conditions => {:source_item_id => FROST_EMBLEM_ARMORY_ID}, :order => ['items.dps DESC']

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
    wowarmory_id
  end
end

class WowHelpers
  QUALITY_ADJECTIVE_LOOKUP = {0 => "poor", 1 => "common", 2 => "uncommon", 3 => "rare", 4 => "epic", 5 => "legendary", 6 => "artifact", 7 => "Heirloom"}
  def self.quality_adjective_for(item)
    QUALITY_ADJECTIVE_LOOKUP[item.quality]
  end
end

