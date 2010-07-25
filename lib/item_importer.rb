class ItemImporter
  QUALITY_ADJECTIVE_LOOKUP = {0 => "poor", 1 => "common", 2 => "uncommon", 3 => "rare", 4 => "epic", 5 => "legendary", 6 => "artifact", 7 => "heirloom"}
  RANGED_WEAPONS = ["Bow", "Gun", "Crossbow", "Thrown"]
  #Unknown 18, 23, 27
  SLOT_CONVERSION = {1 => "Helm", 2 => "Amulet", 3 => "Shoulder", 4 => "Shirt", 5 => "Chest", 6 => "Waist", 7 => "Legs", 8 => "Feet", 
    9 => "Wrist", 10 => "Hands", 11 => "Finger", 12 => "Trinket", 13 => "One-Hand", 14 => "Shield", 15 => "Ranged", 16 => "Back", 
    17 => "Two-Hand", 19 => "Tabard", 20 => "Chest", 21 => "Main Hand", 22 => "Off Hand (Weapon)", 23 => "Off Hand", 24 => "Projectile", 25 => "Ranged", 
    26 => "Ranged", 28 => "Relic"}
  attr_reader :wowarmory_item, :wowarmory_item_id
  def initialize(wowarmory_item, wowarmory_item_id)
    @wowarmory_item = wowarmory_item
    @wowarmory_item_id = wowarmory_item_id
  end
  
  def type_to_be_imported
    if wowarmory_item.gem_properties
      GemItem
    else
      Item
    end
  end
  
  def import!
    returning type_to_be_imported.find_or_create_by_wowarmory_item_id(wowarmory_item_id) do |item|
      item.update_attributes!(:wowarmory_item_id => wowarmory_item_id, :name => wowarmory_item.name,
                   :quality => quality, :icon => wowarmory_item.icon, :bonuses => get_item_bonuses, 
                   :armor_type => ArmorType.find_or_create_by_name(armor_type_name), :slot => slot, 
                   :restricted_to => get_restricted_to, :item_sources => get_item_sources(item), 
                   :gem_color => get_gem_color, :gem_sockets => get_gem_sockets, :socket_bonuses => get_socket_bonuses,
                   :bonding => get_item_bonding, :side => Item::ANY_SIDE, :item_level => get_item_level, 
                   :required_level => get_required_level, :spell_effects => get_spell_effects)
    end
  end
  
  def get_spell_effects
    spells = wowarmory_item.instance_variable_get(:@tooltip).instance_variable_get(:@spells) || []
    spells.map do |spell|
      {:description => spell.description, :trigger => spell.trigger}
    end
  end
  
  def get_required_level
    wowarmory_item.instance_variable_get(:@tooltip).required_level
  end
  
  def get_item_level
    wowarmory_item.instance_variable_get(:@info).level
  end
  
  def get_item_bonding
    bonding = wowarmory_item.instance_variable_get(:@tooltip).bonding
    bonding == 1 ? Item::BOP : Item::BOE
  end

  def get_socket_bonuses
    begin
      ItemSocketImporter.new(wowarmory_item_id).get_socket_bonuses.extract_bonuses
    rescue Exception => ex
      Rails.logger.error(ex)
    end
  end
  
  def get_gem_color
    if wowarmory_item.gem_properties
      wowarmory_item.instance_variable_get(:@info).instance_variable_get(:@type)
    else
      nil
    end
  end
  
  def get_gem_sockets
     wowarmory_item.instance_variable_get(:@tooltip).sockets || []
  end
  
  def get_dropped_area(item)
    area_id = wowarmory_item.item_source.area_id
    if area_id.nil? #pvp items from VOA
      area = Area.find_by_name(wowarmory_item.drop_creatures.first.area)
    else
      area_name = wowarmory_item.item_source.area_name.blank? ? wowarmory_item.drop_creatures.first.area : wowarmory_item.item_source.area_name
      area_difficulty = wowarmory_item.item_source.difficulty.blank? ? Area::NORMAL : wowarmory_item.item_source.difficulty
      area = Area.find_or_create_by_wowarmory_area_id_and_difficulty_and_name(area_id, area_difficulty, area_name)
    end
    DroppedSource.create(:source_area => area, :item => item)
  end
  
  def get_item_sources(item)
    returning([]) do |sources|
      if wowarmory_item.drop_creatures.try(:first)
        sources << get_dropped_area(item)
      end
      if wowarmory_item.cost && wowarmory_item.cost.tokens
        if wowarmory_item.cost.tokens.length == 1 #TODO: determine the cost of items that cost more then one kind of thing
          source_wowarmory_item_id = wowarmory_item.cost.tokens.first.instance_variable_get(:@id)
          token_cost = wowarmory_item.cost.tokens.first.count
          sources << EmblemSource.create(:wowarmory_token_item_id => source_wowarmory_item_id, :token_cost => token_cost, :item => item)
        end
      end
      if wowarmory_item.cost && wowarmory_item.cost.arena_price
        sources << ArenaSource.create(:arena_point_cost => wowarmory_item.cost.arena_price,:honor_point_cost => wowarmory_item.cost.honor_price, :item => item)
      elsif wowarmory_item.cost && wowarmory_item.cost.honor_price
        sources << HonorSource.create(:honor_point_cost => wowarmory_item.cost.honor_price, :item => item)
      end
    end
  end
  
  def get_restricted_to
    allowable_classes = wowarmory_item.instance_variable_get(:@tooltip).allowable_classes
    #if there is only one allowable class, we care
    allowable_classes && allowable_classes.length == 1 ? allowable_classes.first : Item::RESTRICT_TO_NONE
  end
  
  def armor_type_name
    wowarmory_item.equip_data.subclass_name ? wowarmory_item.equip_data.subclass_name : "Miscellaneous"
  end

  def slot
    SLOT_CONVERSION[wowarmory_item.equip_data.inventory_type]
  end
  
  def get_item_bonuses
    returning wowarmory_item.bonuses do |bonuses|
      if wowarmory_item.gem_properties
        bonuses.merge!(wowarmory_item.gem_properties.extract_bonuses)
      elsif damage = wowarmory_item.instance_variable_get(:@tooltip).instance_variable_get(:@damage) #wow wtf wowr gem you fucking suck, seriously.
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
    begin
      wowarmory_item = api.get_item(wowarmory_item_id)
      ItemImporter.new(wowarmory_item, wowarmory_item_id).import!
    rescue Wowr::Exceptions::ItemNotFound => e
      STDERR.puts e
    end
  end

  def self.import_all_items_that_contain!(term)
    items = api.search_items(term)
    items.map do |item|
      import_from_wowarmory!(item.id)
    end
  end

end
