Factory.define(:creature) do |model|
  model.name "Foo"
  model.association :area, :factory => :dungeon
  model.classification "0"
end

Factory.define(:boss, :class => :creature) do |model|
  model.name "Foo"
  model.association :area, :factory => :dungeon
  model.classification "3"
end

Factory.define(:dungeon_creature, :class => :creature) do |model|
  model.classification "1"
  model.name "dungeon mob"
  model.association :area, :factory => :dungeon
end

Factory.define(:raid_10_creature, :class => :creature) do |model|
  model.classification "1"
  model.name "raid 10 mob"
  model.association :area, :factory => :raid_10
end

Factory.define(:raid_25_creature, :class => :creature) do |model|
  model.classification "1"
  model.name "raid 25 mob"
  model.association :area, :factory => :raid_25
end
