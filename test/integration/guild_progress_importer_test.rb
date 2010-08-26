require File.dirname(__FILE__) + '/../test_helper'

class GuildProgressImporterTest < ActiveSupport::TestCase
  GUILD_PROGRESS_PATH = "#{RAILS_ROOT}/test/fixtures/guilds/guild_progress.html"
  context "process_response" do
    teardown do
      Resque.redis.del "queue:guild_crawler_jobs"
    end
  
    should "import several guilds" do
      doc = Nokogiri::HTML(File.read(GUILD_PROGRESS_PATH))
      guild_importer = GuildProgressImporter.new
      assert_difference "Guild.count", 30 do
        assert_difference "Resque.size('guild_crawler_jobs')", 30 do
          guild_importer.process_response(doc)
        end
      end
      black_division = Guild.find_by_name("Black Division")
      assert_equal "Black Division", black_division.name
      assert_equal "Drak'thul", black_division.realm
      assert_equal "eu", black_division.locale
      vodka = Guild.find_by_name("vodka")
      assert_equal "vodka", vodka.name
      assert_equal "Alterac Mountains", vodka.realm
      assert_equal "us", vodka.locale
    end
  end
end
