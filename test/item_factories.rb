Factory.define(:item) do |model|
  model.name "Factory Item"
  model.icon "Factory_icon.png"
  model.wowarmory_item_id 1
  model.bonuses :attack_power => 100
  model.armor_type ArmorType.mail
end

Factory.define(:ring, :parent => :item) do |model|
  model.armor_type ArmorType.miscellaneous
  model.slot "Finger"
end

Factory.define(:ring_from_frost_emblem, :parent => :ring) do |model|
  model.after_create do |item|
    dropped_source = Factory(:frost_emblem_source, :item => item)
  end
end

Factory.define(:polearm, :parent => :item) do |model|
  model.armor_type ArmorType.polearm
  model.slot "Two-Hand"
end

Factory.define(:item_from_emblem_of_triumph, :parent => :item) do |model|
  model.bonuses :attack_power => 200
  model.after_create do |item|
    Factory(:triumph_emblem_source, :item => item)
  end
end

Factory.define(:item_from_heroic_dungeon, :parent => :item) do |model|
  model.bonuses :attack_power => 200
  model.after_create do |item|
    Factory(:dungeon_dropped_source, :item => item)
  end
end

Factory.define(:item_from_heroic_raid, :parent => :item) do |model|
  model.bonuses :attack_power => 200
  model.after_create do |item|
    Factory(:raid_dropped_source, :item => item)
  end
end

Factory.define(:item_from_emblem_of_frost, :parent => :item) do |model|
  model.bonuses :attack_power => 200
  model.after_create do |item|
    Factory(:frost_emblem_source, :item => item)
  end
end

Factory.define(:item_from_honor_points, :parent => :item) do |model|
  model.bonuses :attack_power => 200
  model.after_create do |item|
    Factory(:honor_point_source, :item => item)
  end
end

Factory.define(:item_from_arena_points, :parent => :item) do |model|
  model.bonuses :attack_power => 200
  model.after_create do |item|
    Factory(:arena_point_source, :item => item)
  end
end

Factory.define(:item_from_wintergrasp_marks, :parent => :item) do |model|
  model.bonuses :attack_power => 200
  model.after_create do |item|
    Factory(:wintergrasp_source, :item => item)
  end
end

Factory.define(:item_from_25_man_raid, :parent => :item) do |model|
  model.bonuses :attack_power => 200
  model.after_create do |item|
    Factory(:twenty_five_man_raid_source, :item => item)
  end
end

Factory.define(:item_from_10_man_raid, :parent => :item) do |model|
  model.bonuses :attack_power => 200
  model.after_create do |item|
    Factory(:ten_man_raid_source, :item => item)
  end
end

Factory.define(:fist_from_emblem_of_frost, :parent => :item_from_emblem_of_frost) do |model|
  model.armor_type ArmorType.fist_weapon
  model.slot "One-Hand"
end

