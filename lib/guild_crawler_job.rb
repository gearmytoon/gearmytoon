require 'resque/plugins/lock'
class GuildCrawlerJob
  extend Resque::Plugins::Lock

  @queue = :character_crawler_jobs
  def self.perform(character_id)
  end

end
