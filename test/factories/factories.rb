Factory.define(:free_access_user, :class => "User") do |f|
  f.sequence(:email) {|n| "free_access_#{n}@foo.com" }
  f.password "password"
  f.password_confirmation "password"
  f.free_access true
end

Factory.define(:guild) do |model|
  model.realm "Baelgun"
  model.locale 'us'
  model.name "Special Circumstances"
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

Factory.define(:character_item) do |model|
  model.association :character
  model.association :item
end

Factory.define(:currency_item, :class => 'ItemUsedToCreate') do |model|
end

Factory.define(:container) do |model|
  model.name "some container"
  model.wowarmory_container_id 2
  model.association :area, :factory => :dungeon
end

Factory.define(:quest) do |model|
  model.name "A tale of 2 cities"
  model.level 80
  model.suggested_party_size "5"
  model.required_min_level 80
  model.wowarmory_quest_id 1
  model.association :area, :factory => :dungeon
end

Factory.define(:user_character) do |model|
  model.association :subscriber, :factory => :user
  model.association :character, :factory => :unpaid_character
end

Factory.define(:character_refresh) do |model|
  model.association :character, :factory => :new_character
end

Factory.define(:creature) do |model|
  model.name "Foo"
  model.association :area, :factory => :dungeon
end

Factory.define(:dungeon_creature, :class => :creature) do |model|
  model.name "dungeon mob"
  model.association :area, :factory => :dungeon
end

Factory.define(:raid_10_creature, :class => :creature) do |model|
  model.name "raid 10 mob"
  model.association :area, :factory => :raid_10
end

Factory.define(:raid_25_creature, :class => :creature) do |model|
  model.name "raid 25 mob"
  model.association :area, :factory => :raid_25
end

Factory.define(:trade_skill) do |model|
  model.wowarmory_name "trade_blacksmithing"
end

Factory.define(:item_popularity) do |model|
  model.association :item
end

Factory.define(:comment) do |model|
  model.association :user
  model.comment "hello world"
  model.association :commentable, :factory => :item
end
