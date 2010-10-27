require File.dirname(__FILE__) + '/../test_helper'

class CharacterCrawlerJobTest < ActiveSupport::TestCase
  setup do
    CharacterImporter.stubs(:find_or_import_item).returns(Factory(:item))
    CharacterImporter.stubs(:find_or_import_gem_item).returns(Factory(:red_gem))
  end
  should "import a character and find related characters" do
    WowClass.create_class!("Paladin")
  
    character = Factory(:character, :name => "Rails", :realm => "Baelgun")
    assert_difference "Resque.size('character_crawler_jobs')", 2 do
      assert_difference "Character.count", 2 do
        CharacterCrawlerJob.perform(character.id)
      end
    end
  end
  
  should "import a characters guild" do
    WowClass.create_class!("Priest")
    character = Factory(:character, :name => "Wolor", :realm => "Baelgun", :guild => nil)
    assert_difference "Resque.size('guild_crawler_jobs')" do
      assert_difference "Guild.count" do
        CharacterCrawlerJob.perform(character.id)
      end
    end
    character.reload
    assert_equal "Wipes on Trash", character.guild.name
    assert_equal "Baelgun", character.guild.realm
    assert_equal "us", character.guild.locale
  end

  should "not import a characters guild if it is not new" do
    WowClass.create_class!("Priest")
    Factory(:guild, :name => "Wipes on Trash", :realm => "Baelgun")
    character = Factory(:character, :name => "Wolor", :realm => "Baelgun", :guild => nil)
    assert_no_difference "Resque.size('guild_crawler_jobs')" do
      assert_no_difference "Guild.count" do
        CharacterCrawlerJob.perform(character.id)
      end
    end
  end

end
