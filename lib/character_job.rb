class CharacterJob
  @queue = :character_jobs
  
  def self.perform(character_refresh_id)
    character = CharacterRefresh.find(character_refresh_id).character
    CharacterImporter.refresh_character!(character)
    character.loaded!
    rescue Wowr::Exceptions::CharacterNotFound
      character.unable_to_load!
  end
end