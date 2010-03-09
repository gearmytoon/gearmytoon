Factory.define(:character) do |model|
  model.wow_class WowClass.create!(WowClass::WowClassConstants::Hunter)
end

Factory.define(:a_rogue, :parent => :character) do |model|
  model.wow_class WowClass.create!(WowClass::WowClassConstants::Rogue)
end

Factory.define(:item) do |model|
  model.name "Factory Item"
  model.icon "Factory_icon.png"
  model.wowarmory_id 1
  model.bonuses :attack_power => 100
  model.armor_type ArmorType.Mail
end

Factory.define(:item_from_emblem_of_triumph, :parent => :item) do |model|
  model.source_item_id Item::TRIUMPH_EMBLEM_ARMORY_ID
end

Factory.define(:item_from_heroic_dungeon, :parent => :item) do |model|
  model.dungeon_id Item::DUNGEONS.first
end

Factory.define(:item_from_emblem_of_frost, :parent => :item) do |model|
  model.source_item_id Item::FROST_EMBLEM_ARMORY_ID
end

Factory.define(:character_item) do |model|
  model.association :character
  model.association :item
end

Factory.define(:wow_class) do |model|
  model.primary_armor_type ArmorType.Mail
end
