require File.dirname(__FILE__) + '/../test_helper'

class GuildXmlProcessorTest < ActiveSupport::TestCase
  GUILD_XML_PATH = File.join(RAILS_ROOT, "test", "fixtures", "guilds", "guild_info.xml")
  ARENA_XML_PATH = File.join(RAILS_ROOT, "test", "fixtures", "arena_team", "3v3team.xml")
  
  context "process guild xml" do
    should "find guild realm" do
      doc = Nokogiri::XML(File.read(GUILD_XML_PATH))
      guild_processor = GuildXmlProcessor.new(doc)
      assert_equal "Baelgun", guild_processor.realm
    end
    should "find all 80 characters" do
      doc = Nokogiri::XML(File.read(GUILD_XML_PATH))
      guild_processor = GuildXmlProcessor.new(doc)
      assert_equal 207, guild_processor.level_80_characters.size
    end

    should "find all characters" do
      doc = Nokogiri::XML(File.read(GUILD_XML_PATH))
      guild_processor = GuildXmlProcessor.new(doc)
      assert_equal 308, guild_processor.characters_hash.size
    end
  end
  
  context "process arena team xml" do
    should "find all characters" do
      doc = Nokogiri::XML(File.read(ARENA_XML_PATH))
      guild_processor = GuildXmlProcessor.new(doc)
      assert_equal 2, guild_processor.characters_hash.size
    end
  end
  
end
