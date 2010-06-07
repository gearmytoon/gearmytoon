Factory.define(:item) do |model|
  model.name "Factory Item"
  model.icon "Factory_icon.png"
  model.wowarmory_item_id 1
  model.bonuses :attack_power => 100
  model.armor_type ArmorType.mail
end

Factory.define(:red_gem, :class => "Item") do |model|
  model.name "Factory Gem"
  model.icon "Factory_icon.png"
  model.wowarmory_item_id 999
  model.bonuses :attack_power => 100
  model.armor_type ArmorType.miscellaneous
  model.restricted_to "NONE"
  model.gem_color "Red"
  model.quality "rare"
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
