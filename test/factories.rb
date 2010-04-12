Factory.define(:character) do |model|
  model.name "Merb"
  model.total_item_bonuses {}
  model.realm "Baelgun"
  model.locale 'us'
  model.battle_group "Shadowburn"
  model.guild "Special Circumstances"
  model.level 80
  model.wow_class WowClass.create_class!("Hunter")
  model.dont_use_wow_armory true
end

Factory.define(:user) do |f|
  f.email "foo@foo.com"
  f.password "password"
  f.password_confirmation "password"
end

Factory.define(:invite) do |f|
  f.email "foo@bar.com"
end

Factory.define(:admin, :parent => :user) do |f|
  f.email "admin@gearmytoon.com"
  f.admin true
end

Factory.define(:survival_hunter, :parent => :character) do |model|
  model.name "Merb"
  model.wow_class WowClass.create_class!("Hunter")
  model.primary_spec "Survival"
end

Factory.define(:marksmanship_hunter, :parent => :character) do |model|
  model.name "Ecma"
  model.wow_class WowClass.create_class!("Hunter")
  model.primary_spec "Marksmanship"
end

Factory.define(:a_rogue, :parent => :character) do |model|
  model.wow_class WowClass.create_class!("Rogue")
end

Factory.define(:a_hunter, :parent => :character) do |model|
  model.wow_class WowClass.create_class!("Hunter")
end

require File.dirname(__FILE__) + '/item_factories'

Factory.define(:character_item) do |model|
  model.association :character
  model.association :item
end

Factory.define(:wow_class) do |model|
  model.primary_armor_type ArmorType.mail
end


Factory.define(:dungeon_dropped_source, :class => :dropped_source) do |model|
  model.association :source_area, :factory => :dungeon
end

Factory.define(:raid_dropped_source, :class => :dropped_source) do |model|
  model.association :source_area, :factory => :raid
end

Factory.define(:frost_emblem_source, :class => :emblem_source) do |model|
  model.token_cost 60
  model.wowarmory_token_item_id Item::FROST_EMBLEM_ARMORY_ID
end

Factory.define(:triumph_emblem_source, :class => :emblem_source) do |model|
  model.token_cost 45
  model.wowarmory_token_item_id Item::TRIUMPH_EMBLEM_ARMORY_ID
end

Factory.define(:honor_point_source, :class => :honor_source) do |model|
  model.honor_point_cost 45000
end

Factory.define(:wintergrasp_source, :class => :emblem_source) do |model|
  model.token_cost 15
  model.wowarmory_token_item_id Item::WINTERGRASP_MARK_OF_HONOR
end

Factory.define(:dungeon, :class => :area) do |model|
  model.name "Super Fun Unicorn Land"
  model.wowarmory_area_id Area::DUNGEONS.first
end

Factory.define(:raid, :class => :area) do |model|
  model.name "Super DUPER Fun Unicorn Land"
  model.wowarmory_area_id Area::RAIDS.first
end

