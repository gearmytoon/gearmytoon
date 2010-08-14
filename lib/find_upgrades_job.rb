require 'resque/plugins/lock'
class FindUpgradesJob
  extend Resque::Plugins::Lock
  
  @queue = :find_upgrades_jobs

  def self.perform(character_id)
    character = Character.find(character_id)
    Character.transaction do
      begin
        CharacterImporter.refresh_character!(character)
      rescue Wowr::Exceptions::CharacterNotFound, Wowr::Exceptions::NetworkTimeout
        character.unable_to_load!
      end
    end
  end
end
