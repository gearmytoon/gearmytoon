require File.dirname(__FILE__) + '/../test_helper'

class GuildTest < ActiveSupport::TestCase
  context "find_by_name_or_create" do
    should "create" do
      assert_difference "Guild.count" do
        guild = Guild.find_or_create("Wipes on Trash", "Baelgun", "us")
        assert_equal "Wipes on Trash", guild.name
        assert_equal "Baelgun", guild.realm
        assert_equal "us", guild.locale
      end
    end
    should "find existing" do
      guild = Guild.find_or_create("Wipes on Trash", "Baelgun", "us")
      assert_no_difference "Guild.count" do
        same_guild = Guild.find_or_create("Wipes on Trash", "Baelgun", "us")
        assert_equal guild, same_guild
      end
    end
    should "find existing regardless of realm casing" do
      guild = Guild.find_or_create("Wipes on Trash", "BaeLgun", "us")
      assert_no_difference "Guild.count" do
        same_guild = Guild.find_or_create("Wipes on Trash", "BaElgun", "us")
        assert_equal guild, same_guild
      end
    end
    should "find existing regardless of locale casing" do
      guild = Guild.find_or_create("Wipes on Trash", "baelgun", "US")
      assert_no_difference "Guild.count" do
        same_guild = Guild.find_or_create("Wipes on Trash", "baelgun", "us")
        assert_equal guild, same_guild
      end
    end
  end
end
