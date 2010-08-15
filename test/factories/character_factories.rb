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
