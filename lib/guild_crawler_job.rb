require 'resque/plugins/lock'
class GuildCrawlerJob
  extend Resque::Plugins::Lock

  @queue = :guild_crawler_jobs
  def self.perform(guild_id)
    guild = Guild.find(guild_id)
    importer = WowArmoryImporter.new(false)
    doc = importer.guild_info(guild.name, guild.realm, guild.locale)
    processor = MemberXmlProcessor.new(doc)
    processor.find_more_characters(guild.locale)
  end

end
