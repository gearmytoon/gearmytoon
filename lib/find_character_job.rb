class FindCharacterJob
  @queue = :find_character_jobs

  def self.perform(character_id)
    character = Character.find(character_id)
    Character.transaction do
      begin
        CharacterImporter.import_character!(character)
      rescue Wowr::Exceptions::CharacterNotFound, Wowr::Exceptions::NetworkTimeout
        character.unable_to_load!
      end
    end
    unless character.reload.does_not_exist?
      Character.transaction do
        character.generate_upgrades
      end
    end
  end
end
