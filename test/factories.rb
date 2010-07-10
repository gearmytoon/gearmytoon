Factory.define(:basic_character, :class => "Character") do |model|
  model.name "Merb"
  model.total_item_bonuses({:not_a_stat=>1}) #serialize as doesnt save if the hash is empty
  model.realm "Baelgun"
  model.locale 'us'
  model.battle_group "Shadowburn"
  model.guild "Special Circumstances"
  model.level 80
  model.wow_class WowClass.create_class!("Hunter")
  model.race 'troll'
  model.gender 'male'
  model.dont_use_wow_armory true
end

Factory.define(:unpaid_character, :parent => "basic_character") do |model|
  model.after_create do |character|
    character.refreshing!
    character.loaded!
  end
end

Factory.define(:new_character, :parent => "basic_character") do |model|
  model.race nil
  model.gender nil
  model.after_create do |character|
    character.subscribers = [Factory(:free_access_user)]
    character.save!
  end
end

Factory.define(:does_not_exist_character, :parent => "basic_character") do |model|
  model.after_create do |character|
    character.subscribers = [Factory(:free_access_user)]
    character.save!
    character.refreshing!
    character.unable_to_load!
  end
end

Factory.define(:character, :parent => "basic_character") do |model|
  model.after_create do |character|
    character.subscribers = [Factory(:free_access_user)]
    character.save!
    character.refreshing!
    character.loaded!
  end
end
Factory.define(:geared_character, :parent => "basic_character") do |model|
  model.after_create do |character|
    character.subscribers = [Factory(:free_access_user)]
    character.save!
    character.refreshing!
    character.loaded!
    character.found_upgrades!
  end
end

Factory.define(:free_access_user, :class => "User") do |f|
  f.sequence(:email) {|n| "free_access_#{n}@foo.com" }
  f.password "password"
  f.password_confirmation "password"
  f.free_access true
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
  model.association :item
  model.association :source_area, :factory => :dungeon
end

Factory.define(:frost_emblem_source, :class => :emblem_source) do |model|
  model.token_cost 60
  model.association :item
  model.wowarmory_token_item_id Item::FROST_EMBLEM_ARMORY_ID
end

Factory.define(:triumph_emblem_source, :class => :emblem_source) do |model|
  model.token_cost 45
  model.association :item
  model.wowarmory_token_item_id Item::TRIUMPH_EMBLEM_ARMORY_ID
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

Factory.define(:wintergrasp_source, :class => :emblem_source) do |model|
  model.token_cost 15
  model.wowarmory_token_item_id Item::WINTERGRASP_MARK_OF_HONOR
  model.association :item
end

Factory.define(:raid_dropped_source, :class => :dropped_source) do |model|
  model.association :source_area, :factory => :raid_10
  model.association :item
end

Factory.define(:twenty_five_man_raid_source, :class => :dropped_source) do |model|
  model.association :item
  model.association :source_area, :factory => :raid_25
end

Factory.define(:ten_man_raid_source, :class => :dropped_source) do |model|
  model.association :source_area, :factory => :raid_10
  model.association :item
end

Factory.define(:dungeon, :class => :area) do |model|
  model.name "Super Fun Unicorn Land"
  model.wowarmory_area_id Area::DUNGEONS.first
  model.players 5
end

Factory.define(:raid_25, :class => :area) do |model|
  model.name "Super DUPER Fun Unicorn Land (25)"
  model.wowarmory_area_id Area::RAIDS.first
  model.players 25
end

Factory.define(:raid_10, :class => :area) do |model|
  model.name "Super DUPER Fun Unicorn Land (10)"
  model.wowarmory_area_id Area::RAIDS.first
  model.players 10
end

Factory.define(:raid, :parent => :raid_10) do |model|
end

Factory.define(:considering_payment, :class => :payment) do |model|
  model.raw_data({"something" => "true", "recurringFrequency" => "1 month", "transactionAmount" => "USD 3", "subscriptionId" => "1234"})
  model.association :purchaser, :factory => :user
end

Factory.define(:paid_payment, :parent => :considering_payment) do |model|
  model.after_create do |payment|
    payment.pay!
  end
end

Factory.define(:one_time_paid_payment, :parent => :considering_payment) do |model|
  model.raw_data({"something" => "true", "transactionAmount" => "USD 1"})
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
  model.association :character, :factory => :unpaid_character
end

Factory.define(:character_refresh) do |model|
  model.association :character, :factory => :new_character
end

Factory.define(:upgrade) do |model|
  model.association :character
  model.association :new_item_source, :factory => :frost_emblem_source
  model.old_character_item {|u| Factory(:character_item, :character => u.character, :item => Factory(:downgrade_item))}
  model.for_pvp false
end

Factory.define(:upgrade_from_honor_points, :parent => :upgrade) do |model|
  model.for_pvp true
  model.association :new_item_source, :factory => :honor_point_source
end

Factory.define(:upgrade_from_arena_points, :parent => :upgrade) do |model|
  model.for_pvp true
  model.association :new_item_source, :factory => :arena_point_source
end

Factory.define(:upgrade_from_wintergrasp_marks, :parent => :upgrade) do |model|
  model.for_pvp true
  model.association :new_item_source, :factory => :wintergrasp_source
end

Factory.define(:upgrade_from_emblem_of_triumph, :parent => :upgrade) do |model|
  model.association :new_item_source, :factory => :triumph_emblem_source
end

Factory.define(:upgrade_from_emblem_of_frost, :parent => :upgrade) do |model|
  model.association :new_item_source, :factory => :frost_emblem_source
end

Factory.define(:upgrade_from_heroic_dungeon, :parent => :upgrade) do |model|
  model.association :new_item_source, :factory => :dungeon_dropped_source
end

Factory.define(:upgrade_from_10_raid, :parent => :upgrade) do |model|
  model.association :new_item_source, :factory => :ten_man_raid_source
end

Factory.define(:upgrade_from_25_raid, :parent => :upgrade) do |model|
  model.association :new_item_source, :factory => :twenty_five_man_raid_source
end
