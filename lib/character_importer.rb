class CharacterImporter
  def self.import(name, realm)
    Character.find_or_create_by_name_and_realm(name, realm)
  end
end
