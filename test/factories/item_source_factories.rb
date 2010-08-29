Factory.define(:dungeon_dropped_source, :class => :dropped_source) do |model|
  model.association :item
  model.association :creature, :factory => :dungeon_creature
end

Factory.define(:frost_emblem_source, :class => :purchase_source) do |model|
  model.association :item
  model.after_create do |source|
    source.items_used_to_purchase = [Factory(:currency_item, :wowarmory_item_id => Item::FROST_EMBLEM_ARMORY_ID, :quantity => 60)]
  end
end

Factory.define(:triumph_emblem_source, :class => :purchase_source) do |model|
  model.association :item
  model.after_create do |source|
    source.items_used_to_purchase = [Factory(:currency_item, :wowarmory_item_id => Item::TRIUMPH_EMBLEM_ARMORY_ID, :quantity => 45)]
  end
end

Factory.define(:honor_point_source, :class => :honor_source) do |model|
  model.association :item
  model.honor_point_cost 45000
end

Factory.define(:arena_point_source, :class => :arena_source) do |model|
  model.arena_point_cost 1000
  model.association :item
  model.honor_point_cost 12300
end

Factory.define(:wintergrasp_source, :class => :purchase_source) do |model|
  model.association :item
  model.after_create do |source|
    source.items_used_to_purchase = [Factory(:currency_item, :wowarmory_item_id => Item::WINTERGRASP_MARK_OF_HONOR, :quantity => 15)]
  end
end

Factory.define(:raid_dropped_source, :class => :dropped_source) do |model|
  model.association :creature, :factory => :raid_10_creature
  model.association :item
end

Factory.define(:twenty_five_man_raid_source, :class => :dropped_source) do |model|
  model.association :item
  model.association :creature, :factory => :raid_25_creature
end

Factory.define(:ten_man_raid_source, :class => :dropped_source) do |model|
  model.association :creature, :factory => :raid_10_creature
  model.association :item
end

Factory.define(:purchase_source) do |model|
  model.association :item
end

Factory.define(:container_source, :class => :container_source) do |model|
  model.association :container
  model.association :item
end

Factory.define(:quest_source, :class => :quest_source) do |model|
  model.association :quest
  model.association :item
end

Factory.define(:created_source, :class => :created_source) do |model|
  model.association :trade_skill
  model.association :item
end
