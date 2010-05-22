class CharacterJob
  @queue = :character_jobs
  
  def self.perform(character_refresh_id)
    character_refresh = CharacterRefresh.find(character_refresh_id)
    CharacterImporter.refresh_character!(character_refresh.character)
    character_refresh.found!
    rescue Wowr::Exceptions::CharacterNotFound
      character_refresh.not_found!
  end
end