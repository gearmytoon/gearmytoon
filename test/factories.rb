Factory.define(:character) do |model|
end

Factory.define(:item) do |model|
end

Factory.define(:item_from_emblem_of_triumph, :class => :item) do |model|
  model.source_item_id Item::TRIUMPH_EMBLEM_ARMORY_ID
end

Factory.define(:item_from_emblem_of_frost, :class => :item) do |model|
  model.source_item_id Item::FROST_EMBLEM_ARMORY_ID
end
