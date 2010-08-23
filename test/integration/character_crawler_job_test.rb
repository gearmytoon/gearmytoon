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
end
