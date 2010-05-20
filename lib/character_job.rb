class CharacterJob
  @queue = :character_jobs
  
  def self.perform(character_id)
    character = Character.find(character_id)
    CharacterImporter.refresh_character!(character)
  end
end