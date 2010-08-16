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

