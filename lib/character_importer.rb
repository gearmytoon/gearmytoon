class CharacterImporter
  def self.import(name, realm)
    Character.find_or_create_by_name_and_realm(name, realm)
  end

  def self.import_character_and_all_items(name, realm)
    returning import(name, realm) do |character|
      api = Wowr::API.new(:character_name => name, :realm => realm, 
                            :local => "tw", :caching => false)
      wow_armor_character = api.get_character
      equipped_items = wow_armor_character.items.map do |equipped_item|
        wow_armory_id = equipped_item.instance_variable_get(:@id)
        item = Item.find_by_wowarmory_id(wow_armory_id)
        item.nil? ? ItemImporter.import_from_wowarmory!(wow_armory_id) : item
      end
      character.update_attributes(:equipped_items => equipped_items, :wow_class => WowClass.find_by_name(wow_armor_character.klass))
      character.save!
    end
  end
end
