Factory.define(:character) do |model|
end

Factory.define(:item) do |model|
  model.name "Factory Item"
  model.icon "Factory_icon.png"
  model.wowarmory_id 1
  model.dps 1
end

Factory.define(:item_from_emblem_of_triumph, :parent => :item) do |model|
  model.source_item_id Item::TRIUMPH_EMBLEM_ARMORY_ID
end

Factory.define(:item_from_emblem_of_frost, :parent => :item) do |model|
  model.source_item_id Item::FROST_EMBLEM_ARMORY_ID
end

Factory.define(:character_item) do |model|
  model.association :character
  model.association :item
end