class ItemImporter
  def self.api
    @@api ||= Wowr::API.new()
  end

  def self.import_from_wowarmory!(wowarmory_id, dps = 0)
    wowarmory_item = api.get_item(wowarmory_id)
   if wowarmory_item.cost && wowarmory_item.cost.tokens
      source_item_id = wowarmory_item.cost.tokens.first.instance_variable_get(:@id) 
    end
    Item.create!(:wowarmory_id => wowarmory_id, :dps => dps, :name => wowarmory_item.name,
                  :quality => wowarmory_item.quality, :inventory_type => wowarmory_item.equip_data.inventory_type,
                  :source_item_id => source_item_id, :icon => wowarmory_item.icon)
  end
end