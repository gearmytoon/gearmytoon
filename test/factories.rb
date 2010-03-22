Factory.define(:character) do |model|
  model.wow_class WowClass.create_class!("Hunter")
end

Factory.define(:survival_hunter, :class => "Character") do |model|
  model.wow_class WowClass.create_class!("Hunter")
  model.primary_spec "Survival"
end

Factory.define(:marksmanship_hunter, :class => "Character") do |model|
  model.wow_class WowClass.create_class!("Hunter")
  model.primary_spec "Marksmanship"
end

Factory.define(:a_rogue, :parent => :character) do |model|
  model.wow_class WowClass.create_class!("Druid")
end

Factory.define(:a_hunter, :parent => :character) do |model|
  model.wow_class WowClass.create_class!("Hunter")
end

Factory.define(:item) do |model|
  model.name "Factory Item"
  model.icon "Factory_icon.png"
  model.wowarmory_item_id 1
  model.bonuses :attack_power => 100
  model.armor_type ArmorType.Mail
end

Factory.define(:item_from_emblem_of_triumph, :parent => :item) do |model|
  model.source_wowarmory_item_id Item::TRIUMPH_EMBLEM_ARMORY_ID
end

Factory.define(:item_from_heroic_dungeon, :parent => :item) do |model|
  model.association :source_area, :factory => :dungeon
end

Factory.define(:item_from_heroic_raid, :parent => :item) do |model|
  model.association :source_area, :factory => :raid
end

Factory.define(:item_from_emblem_of_frost, :parent => :item) do |model|
  model.source_wowarmory_item_id Item::FROST_EMBLEM_ARMORY_ID
end

Factory.define(:character_item) do |model|
  model.association :character
  model.association :item
end

Factory.define(:wow_class) do |model|
  model.primary_armor_type ArmorType.Mail
end

Factory.define(:dungeon, :class => :area) do |model|
  model.name "Super Fun Unicorn Land"
  model.wowarmory_area_id Area::DUNGEONS.first
end

Factory.define(:raid, :class => :area) do |model|
  model.name "Super DUPER Fun Unicorn Land"
  model.wowarmory_area_id Area::RAIDS.first
end
 