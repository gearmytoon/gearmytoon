class ItemImporter
  def self.api
    @@api ||= Wowr::API.new()
  end

  def self.import_from_wowarmory!(wowarmory_item_id)
    if Item.find_by_wowarmory_item_id(wowarmory_item_id).nil?
      begin
        wowarmory_item = api.get_item(wowarmory_item_id)
        if wowarmory_item.cost && wowarmory_item.cost.tokens
          if wowarmory_item.cost.tokens.length == 1 #TODO: determine the cost of items that cost more then one kind of thing
            source_wowarmory_item_id = wowarmory_item.cost.tokens.first.instance_variable_get(:@id)
            token_cost = wowarmory_item.cost.tokens.first.count
          end
        end
        source_area = get_dungeon_source(wowarmory_item)
        armor_type_name = wowarmory_item.equip_data.subclass_name ? wowarmory_item.equip_data.subclass_name : "Miscellaneous"
        Item.create!(:wowarmory_item_id => wowarmory_item_id, :name => wowarmory_item.name,
                     :quality => wowarmory_item.quality, :inventory_type => wowarmory_item.equip_data.inventory_type,
                     :source_wowarmory_item_id => source_wowarmory_item_id, :icon => wowarmory_item.icon, :bonuses => get_item_bonuses(wowarmory_item),
                     :armor_type => ArmorType.find_or_create_by_name(armor_type_name), :token_cost => token_cost,
                     :source_area => source_area)
      rescue Wowr::Exceptions::ItemNotFound => e
        STDERR.puts e
      end
    end
  end

  RANGED_WEAPONS = ["Bow", "Gun", "Crossbow", "Thrown"]

  def self.get_dungeon_source(wowarmory_item)
    if wowarmory_item.drop_creatures.try(:first)
      area_id = wowarmory_item.item_source.area_id
      returning Area.find_or_create_by_wowarmory_area_id_and_difficulty_and_name(area_id, wowarmory_item.item_source.difficulty, wowarmory_item.item_source.area_name) do |source_area|
        source_area.update_attributes(:name => wowarmory_item.item_source.area_name)
      end
    end
  end

  def self.get_item_bonuses(wowarmory_item)
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
      end
    end
  end
end
