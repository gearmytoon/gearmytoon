Factory.define(:dungeon, :class => :area) do |model|
  model.name "Super Fun Unicorn Land"
  model.wowarmory_area_id Area::DUNGEONS.first
  model.players 5
end

Factory.define(:heroic_dungeon, :class => :area) do |model|
  model.name "Super Fun Unicorn Land"
  model.wowarmory_area_id Area::DUNGEONS.first
  model.difficulty Area::HEROIC
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
