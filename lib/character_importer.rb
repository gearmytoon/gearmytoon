class CharacterImporter
  def self.import(character)
    self.import_character_and_all_items(character).save!
  end

  def self.refresh_character!(character)
    character.character_items.delete_all
    import_character_and_all_items(character).save!
  end

  def self.import_character_and_all_items(character)
    returning character do |c|
      api = Wowr::API.new(:character_name => c.name, :realm => c.realm,
                            :local => "tw", :caching => false)
      wow_armory_character = api.get_character
      wow_armory_character.items.each do |equipped_item|
        wow_armory_item_id = equipped_item.instance_variable_get(:@id)
        item = Item.find_by_wowarmory_item_id(wow_armory_item_id)
        item = item.nil? ? ItemImporter.import_from_wowarmory!(wow_armory_item_id) : item
        character.character_items.build(:item => item)
      end
      primary_spec = wow_armory_character.talent_spec.primary
      c.attributes = {:wow_class => WowClass.find_by_name(wow_armory_character.klass),
        :primary_spec => primary_spec, :wowarmory_gender_id => wow_armory_character.gender_id, :gender => wow_armory_character.gender,
        :wowarmory_race_id => wow_armory_character.race_id, :race => wow_armory_character.race, :wowarmory_class_id => wow_armory_character.klass_id,
        :guild => wow_armory_character.guild, :battle_group => wow_armory_character.battle_group, :guild_url => wow_armory_character.guild_url,
        :level => wow_armory_character.level, :total_item_bonuses => {}}
    end
  end
end
