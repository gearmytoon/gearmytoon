desc "import guilds"
task :import_guilds => :environment do
  GuildProgressImporter.new.process_untiL_page(1)
end

desc "requeue guilds"
task :requeue_guilds => :environment do
  Guild.find_in_batches(:select => :id, :conditions => ['id > 240']) do |batch|
    batch.each do |guild|
      Resque.enqueue(GuildCrawlerJob, guild.id)
    end
  end
end
