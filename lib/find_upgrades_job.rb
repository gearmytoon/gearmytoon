require 'resque/plugins/lock'
class FindUpgradesJob
  extend Resque::Plugins::Lock
  
  @queue = :find_upgrades_jobs

  def self.perform(character_id)
    CharacterImporter.find_upgrades!(character_id)
  end
end
