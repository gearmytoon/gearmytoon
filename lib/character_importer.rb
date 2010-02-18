class CharacterImporter
  def self.import(name, realm)
    Character.find_or_create_by_name_and_realm(name, realm)
  end
  def self.import_character_and_all_items(name, realm)
    character = import(name, realm)
    api = Wowr::API.new(:character_name => 'Merb',
                          :realm => 'Baelgun',
                          :local => "tw",
                          :caching => true) # defaults to true

    wow_armor_character = api.get_character
    p wow_armor_character.public_methods(false)
    equipped_items = wow_armor_character.items.map{|item| Item.find_by_wowarmory_id(item.instance_variable_get(:@id))}
    equipped_items.compact!
    character.equipped_items = equipped_items
    character.save!
  end
end
