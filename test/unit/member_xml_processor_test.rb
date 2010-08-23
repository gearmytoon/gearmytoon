require File.dirname(__FILE__) + '/../test_helper'

class MemberXmlProcessorTest < ActiveSupport::TestCase
  GUILD_XML_PATH = File.join(RAILS_ROOT, "test", "fixtures", "guilds", "guild_info.xml")
  CHAR_XML_PATH = File.join(RAILS_ROOT, "test", "fixtures", "characters", "rails-info.xml")
  
  context "process guild xml" do
    should "find guild realm" do
      doc = Nokogiri::XML(File.read(GUILD_XML_PATH))
      guild_processor = MemberXmlProcessor.new(doc)
      assert_equal "Baelgun", guild_processor.realm
    end
    should "find all 80 characters" do
      doc = Nokogiri::XML(File.read(GUILD_XML_PATH))
      guild_processor = MemberXmlProcessor.new(doc)
      assert_equal 207, guild_processor.level_80_characters.size
    end

    should "find all characters" do
      doc = Nokogiri::XML(File.read(GUILD_XML_PATH))
      guild_processor = MemberXmlProcessor.new(doc)
      assert_equal 308, guild_processor.characters_hash.size
    end
  end
  
  context "process character xml" do
    should "find all characters" do
      doc = Nokogiri::XML(File.read(CHAR_XML_PATH))
      guild_processor = MemberXmlProcessor.new(doc)
      assert_equal 4, guild_processor.characters_hash.size
    end
  end

  context "find_more_characters" do
    should "find more characters to import" do
      WowClass.create_class!("Paladin")
      doc = Nokogiri::XML(File.read(CHAR_XML_PATH))
      processor = MemberXmlProcessor.new(doc)
      character = Factory(:character, :name => "Rails", :realm => "Baelgun")
      assert_difference "Resque.size('character_crawler_jobs')", 2 do
        assert_difference "Character.count", 2 do
          processor.find_more_characters("us")
        end
      end
      assert_not_nil Character.find_by_name("escath")
      assert_not_nil Character.find_by_name("serenade")
    end
  end
  
end
