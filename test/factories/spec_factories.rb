Factory.define(:spec) do |model|
  model.wow_class WowClass.find_or_create_class!("Hunter")
  model.name "Survival"
end

Factory.define(:survival_hunter_spec, :class => "Spec") do |model|
  model.wow_class WowClass.find_or_create_class!("Hunter")
  model.name "Survival"
end

Factory.define(:marks_hunter_spec, :class => "Spec") do |model|
  model.wow_class WowClass.find_or_create_class!("Hunter")
  model.name "Marksmanship"
end

Factory.define(:combat_rogue_spec, :class => "Spec") do |model|
  model.wow_class WowClass.find_or_create_class!("Rogue")
  model.name "Combat"
end

Factory.define(:enhance_shaman_spec, :class => "Spec") do |model|
  model.wow_class WowClass.find_or_create_class!("Shaman")
  model.name "Enhancement"
end

Factory.define(:beast_mastery_hunter_spec, :class => "Spec") do |model|
  model.wow_class WowClass.find_or_create_class!("Hunter")
  model.name "Beast Mastery"
end

Factory.define(:death_knight_blood_spec, :class => "Spec") do |model|
  model.wow_class WowClass.find_or_create_class!("Death Knight")
  model.name "Blood"
end
