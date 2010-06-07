class CharacterImporter
  def self.import(character)
    self.import_character_and_all_items(character).save!
  end

  def self.refresh_character!(character)
    character.character_items.delete_all
    import_character_and_all_items(character).save!
    character.generate_upgrades
    character
  end

  def self.find_or_import_item(wow_armory_item_id)
    return nil if wow_armory_item_id.nil?
    item = Item.find_by_wowarmory_item_id(wow_armory_item_id)
    item = item.nil? ? ItemImporter.import_from_wowarmory!(wow_armory_item_id) : item  
  end

  def self.import_character_and_all_items(character)
    returning character do |c|
      api = Wowr::API.new(:character_name => c.name, :realm => c.realm,
      :locale => c.locale, :caching => false)
      wow_armory_character = api.get_character
      wow_armory_character.items.each do |equipped_item|
        wow_armory_item_id = equipped_item.instance_variable_get(:@id)
        item = find_or_import_item(wow_armory_item_id)
        character_item = character.character_items.build(:item => item, :gem_one => find_or_import_item(equipped_item.gems[0]),
                                                                      :gem_two => find_or_import_item(equipped_item.gems[1]),
                                                                      :gem_three => find_or_import_item(equipped_item.gems[2]))
      end
      primary_spec = wow_armory_character.talent_spec.primary
      c.attributes = {:wow_class => WowClass.find_by_name(wow_armory_character.klass),
        :primary_spec => primary_spec, :wowarmory_gender_id => wow_armory_character.gender_id, :gender => wow_armory_character.gender,
        :wowarmory_race_id => wow_armory_character.race_id, :race => wow_armory_character.race, :wowarmory_class_id => wow_armory_character.klass_id,
        :guild => wow_armory_character.guild, :battle_group => wow_armory_character.battle_group, :guild_url => wow_armory_character.guild_url,
      :level => wow_armory_character.level, :total_item_bonuses => get_total_stats(wow_armory_character), :updated_at => Time.now.utc}
    end
  end

  def self.get_total_stats(wow_armory_character)
    #need to calc the effective, bug in the wowr gem
    attack_power = wow_armory_character.melee.power.haste_rating - wow_armory_character.melee.power.base
     {:hit => wow_armory_character.melee.hit_rating.value, :agility => wow_armory_character.agility.effective,
      :strength => wow_armory_character.strength.effective, :intellect => wow_armory_character.intellect.effective,
      :spirit => wow_armory_character.spirit.effective, :stamina => wow_armory_character.stamina.effective,
      :armor => wow_armory_character.defenses.armor.effective, :defense => wow_armory_character.defenses.defense.value,
      :dodge => wow_armory_character.defenses.dodge.rating, :parry => wow_armory_character.defenses.parry.rating,
      :block => wow_armory_character.defenses.block.rating, :resilience => wow_armory_character.defenses.resilience.value,
      :expertise => wow_armory_character.melee.expertise.value, :attack_power => attack_power,
      :crit => wow_armory_character.melee.crit_chance.rating, :haste => wow_armory_character.spell.speed.haste_rating,
      :mana_regen => wow_armory_character.spell.mana_regen.not_casting, :spell_power => wow_armory_character.spell.bonus_healing,
      :spell_penetration => wow_armory_character.spell.penetration, :armor_penetration => wow_armory_character.melee.hit_rating.armor_penetration}
  end
end
