class ItemImporter
  def self.api
    @@api ||= Wowr::API.new()
  end

  def self.import_from_wowarmory!(wowarmory_id)
    wowarmory_item = api.get_item(wowarmory_id)
   if wowarmory_item.cost && wowarmory_item.cost.tokens
      source_item_id = wowarmory_item.cost.tokens.first.instance_variable_get(:@id) 
    end
    Item.create!(:wowarmory_id => wowarmory_id, :name => wowarmory_item.name,
                  :quality => wowarmory_item.quality, :inventory_type => wowarmory_item.equip_data.inventory_type,
                  :source_item_id => source_item_id, :icon => wowarmory_item.icon, :bonuses => wowarmory_item.bonuses,
                  :armor_type => ArmorType.find_or_create_by_name(wowarmory_item.equip_data.subclass_name))
  end
end