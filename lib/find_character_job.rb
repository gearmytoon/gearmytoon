require 'resque/plugins/lock'
class FindCharacterJob
  extend Resque::Plugins::Lock
  
  @queue = :find_character_jobs

  def self.perform(character_id)
    CharacterImporter.import_and_generate_upgrades!(character_id)
  end
end
