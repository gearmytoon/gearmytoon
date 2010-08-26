desc "import guilds"
task :import_guilds => :environment do
  GuildProgressImporter.new.process_untiL_page(1)
end