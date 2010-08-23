require 'resque/plugins/lock'
class CharacterCrawlerJob
  extend Resque::Plugins::Lock
  
  @queue = :character_crawler_jobs
  def self.perform(character_id)
    CharacterImporter.import_and_crawl_associated!(character_id)
  end
end
