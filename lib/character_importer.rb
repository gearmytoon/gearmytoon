class CharacterImporter

  def self.import_and_generate_upgrades!(character_id)
    character = Character.find(character_id)
    import!(character)
    unless character.reload.does_not_exist?
      Character.transaction do
        character.generate_upgrades
      end
    end
  end
  
  def self.import_and_crawl_associated!(character_id)
    character = Character.find(character_id)
    character = import!(character)
    if character.found?
      armory = WowArmoryImporter.new(false)
      processor = MemberXmlProcessor.new(armory.character_sheet(character.name, character.realm, character.locale))
      processor.find_more_characters(character.locale)
      #TODO: clean this up, very very dirty.
      if !@@guild_exists
        Resque.enqueue(GuildCrawlerJob, character.guild_id)
      end
    end
  end
  
  def self.find_upgrades!(character_id)
    character = Character.find(character_id)
    Character.transaction do
      begin
        refresh_character!(character)
      rescue Wowr::Exceptions::CharacterNotFound, Wowr::Exceptions::NetworkTimeout => ex
        character.unable_to_load!
      end
    end
  end

  def self.import!(character)
    Character.transaction do
      begin
        import_character_and_all_items(character).save!
        character.loaded!
      rescue Wowr::Exceptions::CharacterNotFound, Wowr::Exceptions::NetworkTimeout => ex
        character.unable_to_load!
      end
    end
    character
  end

  def self.refresh_character!(character)
    CharacterItem.delete_all(:character_id => character.id)
    Upgrade.delete_all(:character_id => character.id)
    import!(character)
    character.generate_upgrades
    character
  end

  def self.find_or_import_item(wow_armory_item_id)
    return nil if wow_armory_item_id.nil?
    item = Item.find_by_wowarmory_item_id(wow_armory_item_id)
    item = item.nil? ? ItemImporter.import_from_wowarmory!(wow_armory_item_id) : item  
  end
  
  def self.find_or_import_gem_item(wow_armory_item_id)
    return nil if wow_armory_item_id.nil?
    item = GemItem.find_by_wowarmory_item_id(wow_armory_item_id)
    item = item.nil? ? ItemImporter.import_from_wowarmory!(wow_armory_item_id) : item  
  end

  private
  def self.import_character_and_all_items(character)
    returning character do |c|
      api = Wowr::API.new(:character_name => c.name, :realm => c.realm,
      :locale => c.locale, :caching => false)
      wow_armory_character = api.get_character

      wow_armory_character.items.each do |equipped_item|
        wow_armory_item_id = equipped_item.instance_variable_get(:@id)
        item = find_or_import_item(wow_armory_item_id)
        character_item = character.character_items.build(:item => item, :gem_one => find_or_import_gem_item(equipped_item.gems[0]),
                                                                        :gem_two => find_or_import_gem_item(equipped_item.gems[1]),
                                                                        :gem_three => find_or_import_gem_item(equipped_item.gems[2]))
      end
      primary_spec = wow_armory_character.talent_spec.primary
      point_dist = wow_armory_character.talent_spec.point_distribution
      @@guild_exists = Guild.exists?(wow_armory_character.guild, c.realm, c.locale)
      guild_id = Guild.find_or_create(wow_armory_character.guild,c.realm, c.locale).id
      c.attributes = {:spec => Spec.find_or_create(primary_spec, wow_armory_character.klass),
        :wowarmory_gender_id => wow_armory_character.gender_id, :gender => wow_armory_character.gender,
        :wowarmory_race_id => wow_armory_character.race_id, :race => wow_armory_character.race, :wowarmory_class_id => wow_armory_character.klass_id,
        :guild_id => guild_id, :battle_group => wow_armory_character.battle_group,
      :level => wow_armory_character.level, :total_item_bonuses => get_total_stats(wow_armory_character), 
      :active_talent_point_distribution => point_dist, :updated_at => Time.now.utc}
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
