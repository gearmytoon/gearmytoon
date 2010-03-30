class ItemImporter
  QUALITY_ADJECTIVE_LOOKUP = {0 => "poor", 1 => "common", 2 => "uncommon", 3 => "rare", 4 => "epic", 5 => "legendary", 6 => "artifact", 7 => "heirloom"}
  RANGED_WEAPONS = ["Bow", "Gun", "Crossbow", "Thrown"]
  #Unknown 18, 23, 27
  SLOT_CONVERSION = {1 => "Helm", 2 => "Amulet", 3 => "Shoulder", 4 => "Shirt", 5 => "Chest", 6 => "Waist", 7 => "Legs", 8 => "Feet", 
    9 => "Wrist", 10 => "Hands", 11 => "Finger", 12 => "Trinket", 13 => "One-Hand", 14 => "Off Hand", 15 => "Ranged", 16 => "Back", 
    17 => "Two-Hand", 19 => "Tabard", 20 => "Chest", 21 => "Main Hand", 22 => "Off Hand (Weapon)", 24 => "Projectile", 25 => "Thrown", 
    26 => "Ranged", 28 => "Relic"}
  attr_reader :wowarmory_item, :wowarmory_item_id
  def initialize(wowarmory_item, wowarmory_item_id)
    @wowarmory_item = wowarmory_item
    @wowarmory_item_id = wowarmory_item_id
  end
  
  def import!
    if wowarmory_item.cost && wowarmory_item.cost.tokens
      if wowarmory_item.cost.tokens.length == 1 #TODO: determine the cost of items that cost more then one kind of thing
        source_wowarmory_item_id = wowarmory_item.cost.tokens.first.instance_variable_get(:@id)
        token_cost = wowarmory_item.cost.tokens.first.count
      end
    end
    source_area = get_dungeon_source
    Item.create!(:wowarmory_item_id => wowarmory_item_id, :name => wowarmory_item.name,
                 :quality => quality, :inventory_type => wowarmory_item.equip_data.inventory_type,
                 :source_wowarmory_item_id => source_wowarmory_item_id, :icon => wowarmory_item.icon, :bonuses => get_item_bonuses,
                 :armor_type => ArmorType.find_or_create_by_name(armor_type_name), :token_cost => token_cost,
                 :source_area => source_area, :slot => slot)
  end
  
  def armor_type_name
    wowarmory_item.equip_data.subclass_name ? wowarmory_item.equip_data.subclass_name : "Miscellaneous"
  end

  def slot
    SLOT_CONVERSION[wowarmory_item.equip_data.inventory_type]
  end
  def get_dungeon_source
    if wowarmory_item.drop_creatures.try(:first)
      area_id = wowarmory_item.item_source.area_id
      Area.find_or_create_by_wowarmory_area_id_and_difficulty_and_name(area_id, wowarmory_item.item_source.difficulty, wowarmory_item.item_source.area_name)
    end
  end

  def get_item_bonuses
    returning wowarmory_item.bonuses do |bonuses|
      if damage = wowarmory_item.instance_variable_get(:@tooltip).instance_variable_get(:@damage) #wow wtf wowr gem you fucking suck, seriously.
        if RANGED_WEAPONS.include?(wowarmory_item.equip_data.subclass_name)
          weapon_type = "ranged"
        else
          weapon_type = "melee"
        end
        bonuses["#{weapon_type}_min_damage".to_sym] = damage.min
        bonuses["#{weapon_type}_max_damage".to_sym] = damage.max
        bonuses["#{weapon_type}_attack_speed".to_sym] = damage.speed
        bonuses["#{weapon_type}_dps".to_sym] = damage.dps
      end
    end
  end
  
  def quality
    QUALITY_ADJECTIVE_LOOKUP[wowarmory_item.quality]
  end
  

  def self.api
    @@api ||= Wowr::API.new()
  end
  def self.import_from_wowarmory!(wowarmory_item_id)
    if Item.find_by_wowarmory_item_id(wowarmory_item_id).nil?
      begin
        wowarmory_item = api.get_item(wowarmory_item_id)
        ItemImporter.new(wowarmory_item, wowarmory_item_id).import!
      rescue Wowr::Exceptions::ItemNotFound => e
        STDERR.puts e
      end
    end
  end

end
