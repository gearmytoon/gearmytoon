Factory.define(:item) do |model|
  model.name "Factory Item"
  model.icon "Factory_icon.png"
  model.wowarmory_item_id 1
  model.bonuses :attack_power => 100
  model.armor_type ArmorType.mail
end

Factory.define(:item_with_3_gem_sockets, :parent => :item) do |model|
  model.gem_sockets ["Red", "Blue", "Yellow"]
end

Factory.define(:gem, :class => "GemItem") do |model|
  model.bonding Item::BOE
  model.name "Factory Gem"
  model.icon "Factory_icon.png"
  model.wowarmory_item_id 999
  model.bonuses :attack_power => 100
  model.armor_type ArmorType.miscellaneous
  model.restricted_to "NONE"
  model.gem_color GemItem::RED
  model.quality "rare"
end

Factory.define(:prismatic_gem, :parent => :gem) do |model|
  model.gem_color GemItem::PRISMATIC
end

Factory.define(:meta_gem, :parent => :gem) do |model|
  model.gem_color GemItem::META
end

Factory.define(:yellow_gem, :parent => :gem) do |model|
  model.gem_color GemItem::YELLOW
end

Factory.define(:orange_gem, :parent => :gem) do |model|
  model.gem_color GemItem::ORANGE
end

Factory.define(:red_gem, :parent => :gem) do |model|
  model.gem_color GemItem::RED
end

Factory.define(:purple_gem, :parent => :gem) do |model|
  model.gem_color GemItem::PURPLE
end

Factory.define(:blue_gem, :parent => :gem) do |model|
  model.gem_color GemItem::BLUE
end

Factory.define(:green_gem, :parent => :gem) do |model|
  model.gem_color GemItem::GREEN
end


Factory.define(:downgrade_item, :parent => :item) do |model|
  model.bonuses :attack_power => 1
end

Factory.define(:ring, :parent => :item) do |model|
  model.armor_type ArmorType.miscellaneous
  model.slot "Finger"
end

Factory.define(:polearm, :parent => :item) do |model|
  model.armor_type ArmorType.polearm
  model.slot "Two-Hand"
end

Factory.define(:fist_weapon, :parent => :item) do |model|
  model.armor_type ArmorType.fist_weapon
  model.slot "One-Hand"
end
