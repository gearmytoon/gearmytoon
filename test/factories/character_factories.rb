Factory.define(:basic_character, :class => "Character") do |model|
  model.name "Merb"
  model.total_item_bonuses({:not_a_stat=>1}) #serialize as doesnt save if the hash is empty
  model.realm "Baelgun"
  model.locale 'us'
  model.battle_group "Shadowburn"
  model.level 80
  model.association :spec
  model.race 'troll'
  model.gender 'male'
  model.association :guild
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

Factory.define(:survival_hunter, :parent => :character) do |model|
  model.name "Merb"
  model.association :spec, :factory => :survival_hunter_spec
end

Factory.define(:marksmanship_hunter, :parent => :character) do |model|
  model.name "Ecma"
  model.association :spec, :factory => :marks_hunter_spec
end

Factory.define(:a_rogue, :parent => :character) do |model|
  model.association :spec, :factory => :combat_rogue_spec
end

Factory.define(:a_hunter, :parent => :character) do |model|
  model.association :spec, :factory => :survival_hunter_spec
end

Factory.define(:a_shaman, :parent => :character) do |model|
  model.association :spec, :factory => :enhance_shaman_spec
end
