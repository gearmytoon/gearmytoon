class Item
  def self.badge_of_frost
    api = Wowr::API.new
    item = api.get_item(49426)
  end
end
class WowHelpers
  QUALITY_ADJECTIVE_LOOKUP = {0 => "poor", 1 => "common", 2 => "uncommon", 3 => "rare", 4 => "epic", 5 => "legendary", 6 => "artifact", 7 => "Heirloom"}
  def self.quality_adjective_for(item)
    QUALITY_ADJECTIVE_LOOKUP[item.quality]
  end
end