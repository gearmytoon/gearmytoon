class ItemImporter
  def self.api
    @@api ||= Wowr::API.new()
  end

  def self.import_from_wowarmory!(wowarmory_id)
    wowarmory_item = api.get_item(wowarmory_id)
    if wowarmory_item.cost && wowarmory_item.cost.tokens
      if wowarmory_item.cost.tokens.length == 1 #TODO: determine the cost of items that cost more then one kind of thing
        source_item_id = wowarmory_item.cost.tokens.first.instance_variable_get(:@id)
        token_cost = wowarmory_item.cost.tokens.first.count
      end
    end
    if wowarmory_item.drop_creatures.try(:first) && wowarmory_item.item_source.difficulty == 'h' && wowarmory_item.drop_creatures.first.classification == 1
      dungeon_id = wowarmory_item.item_source.area_id
    end
    armor_type_name = wowarmory_item.equip_data.subclass_name ? wowarmory_item.equip_data.subclass_name : "Miscellaneous"
    Item.create!(:wowarmory_id => wowarmory_id, :name => wowarmory_item.name,
                  :quality => wowarmory_item.quality, :inventory_type => wowarmory_item.equip_data.inventory_type,
                  :source_item_id => source_item_id, :icon => wowarmory_item.icon, :bonuses => wowarmory_item.bonuses,
                  :armor_type => ArmorType.find_or_create_by_name(armor_type_name), :token_cost => token_cost,
                  :dungeon_id => dungeon_id)
  end
end
