require File.dirname(__FILE__) + '/../test_helper'

class GuildCrawlerJobTest < ActiveSupport::TestCase
  setup do
    CharacterImporter.stubs(:find_or_import_item).returns(Factory(:item))
    CharacterImporter.stubs(:find_or_import_gem_item).returns(Factory(:red_gem))
  end
  should "import a character and find related characters" do
    WowClass.create_class!("Paladin")
    guild = Factory(:guild, :name => "Wipes on Trash", :realm => "Baelgun", :locale => "us")
    characters_before = Character.count
    jobs_before = Resque.size('character_crawler_jobs')
    GuildCrawlerJob.perform(guild.id)
    characters_after = Character.count
    jobs_after = Resque.size('character_crawler_jobs')

    assert_not_equal characters_after, characters_before
    assert_not_equal jobs_after, jobs_before
    assert_not_equal jobs_after-jobs_before, characters_after- characters_before
  end
end
