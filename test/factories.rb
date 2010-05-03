Factory.define(:character) do |model|
  model.name "Merb"
  model.total_item_bonuses {}
  model.realm "Baelgun"
  model.locale 'us'
  model.battle_group "Shadowburn"
  model.guild "Special Circumstances"
  model.level 80
  model.wow_class WowClass.create_class!("Hunter")
  model.race 'Troll'
  model.dont_use_wow_armory true
end

Factory.define(:user) do |f|
  f.sequence(:email) {|n| "foo#{n}@foo.com" }
  f.password "password"
  f.password_confirmation "password"
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

Factory.define(:arena_point_source, :class => :arena_source) do |model|
  model.arena_point_cost 1000
  model.honor_point_cost 12300
end

Factory.define(:wintergrasp_source, :class => :emblem_source) do |model|
  model.token_cost 15
  model.wowarmory_token_item_id Item::WINTERGRASP_MARK_OF_HONOR
end

Factory.define(:raid_dropped_source, :class => :dropped_source) do |model|
  model.association :source_area, :factory => :raid_10
end

Factory.define(:twenty_five_man_raid_source, :class => :dropped_source) do |model|
  model.association :source_area, :factory => :raid_25
end

Factory.define(:ten_man_raid_source, :class => :dropped_source) do |model|
  model.association :source_area, :factory => :raid_10
end

Factory.define(:dungeon, :class => :area) do |model|
  model.name "Super Fun Unicorn Land"
  model.wowarmory_area_id Area::DUNGEONS.first
end

Factory.define(:raid_25, :class => :area) do |model|
  model.name "Super DUPER Fun Unicorn Land"
  model.wowarmory_area_id Area::RAIDS.first
  model.players 25
end

Factory.define(:raid_10, :class => :area) do |model|
  model.name "Super DUPER Fun Unicorn Land"
  model.wowarmory_area_id Area::RAIDS.first
  model.players 10
end

Factory.define(:raid, :parent => :raid_10) do |model|
end

Factory.define(:considering_payment, :class => :payment) do |model|
  model.recipient_token "recipient_token"
  model.caller_reference "caller_reference"
  model.caller_token "caller_token"
  model.association :purchaser, :factory => :user
end
Factory.define(:paid_payment, :parent => :considering_payment) do |model|
  model.after_create do |payment|
    payment.pay!
  end
end
Factory.define(:failed_payment, :parent => :considering_payment) do |model|
  model.after_create do |payment|
    payment.fail!
  end
end
Factory.define(:user_character) do |model|
  model.association :subscriber, :factory => :user
  model.association :character
end