require File.dirname(__FILE__) + '/../test_helper'

class WowArmoryImporterTest < ActiveSupport::TestCase
  context "cache_path" do
    should "cache in test fixtures if rails env is test" do
      assert_equal File.join(RAILS_ROOT, "test", "fixtures", "wow_armory"), WowArmoryImporter.cache_path("test")
      assert_equal File.join(RAILS_ROOT, "test", "fixtures", "wow_armory"), WowArmoryImporter.cache_path("TEST")
    end
    should "cache in rails root cache otherwise" do
      assert_equal File.join(RAILS_ROOT, "cache", "wow_armory"), WowArmoryImporter.cache_path("production")
    end
  end

  context "caching" do
    should "not hit the web when enabled" do
      wow_armory = WowArmoryImporter.new(true)
      wow_armory.expects(:get_xml).never
      wow_armory.item_tooltip(50638)
    end

    should "not hit the cache when disabled" do
      wow_armory = WowArmoryImporter.new(false)
      wow_armory.expects(:cached_copy).never
      wow_armory.item_tooltip(50638)
    end
  end
  
  context "item data" do
    should "get the tooltip" do
      wi =  WowArmoryImporter.new
      assert_not_nil wi.item_tooltip(50638)
    end

    should "raise an exception if the item does not exist" do
      wi =  WowArmoryImporter.new
      assert_raises WowArmoryDataNotFound do
        wi.item_tooltip(36745)
      end
      assert_raises WowArmoryDataNotFound do
        wi.item_info(36745)
      end
    end

    should "get the info" do
      wi =  WowArmoryImporter.new
      assert_not_nil wi.item_info(50638)
    end
  end
  
  context "character data" do
    should "get the sheet" do
      wi =  WowArmoryImporter.new
      assert_not_nil wi.character_sheet("rails", "baelgun", "us")
    end
    should "get the talents" do
      wi =  WowArmoryImporter.new
      assert_not_nil wi.character_talents("rails", "baelgun", "us")
    end
  end

  context "guild data" do
    should "get guild info" do
      wi =  WowArmoryImporter.new
      assert_not_nil wi.guild_info("wipes on trash", "baelgun", "us")
    end
  end
  
  context "arena data" do
    should "get all arena team data" do
      wi =  WowArmoryImporter.new
      assert_not_nil wi.arena_team("I got nothing", 3, "baelgun", "us")
    end
  end
  
  context "url generation" do
    should "generate item_info urls" do
      wi =  WowArmoryImporter.new
      assert_equal "http://www.wowarmory.com/item-info.xml?i=50638", wi.item_info_url(50638)
    end

    should "generate item_tooltip urls" do
      wi =  WowArmoryImporter.new
      assert_equal "http://www.wowarmory.com/item-tooltip.xml?i=50638", wi.item_tooltip_url(50638)
    end

    should "generate character urls" do
      wi =  WowArmoryImporter.new
      assert_equal "http://www.wowarmory.com/character-sheet.xml?r=baelgun&cn=merb", wi.character_sheet_url("merb", "baelgun", "us")
    end

    should "generate locale specific character urls" do
      wi =  WowArmoryImporter.new
      assert_equal "http://eu.wowarmory.com/character-sheet.xml?r=baelgun&cn=merb", wi.character_sheet_url("merb", "baelgun", "eu")
    end
  end
end