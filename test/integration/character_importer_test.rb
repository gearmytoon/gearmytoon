require File.dirname(__FILE__) + '/../test_helper'

class CharacterImporterTest < ActiveSupport::TestCase
  context "import_character_and_all_items" do
    should "import rails and all of his equipped items" do
      assert_difference "Item.count", 19 do
        Factory(:wow_class, :name => "Hunter")
        Factory(:wow_class, :name => "Paladin")
        character = nil
        assert_difference "Character.count" do
          character = CharacterImporter.import_character_and_all_items("Rails", "Baelgun")
        end
        rails = Character.last
        assert_equal character, rails
        assert !rails.equipped_items.empty?
        assert_equal "Rails", rails.name
        assert_equal 80, rails.level
        assert_equal "Blood Elf", rails.race
        assert_equal 10, rails.wowarmory_race_id
        assert_equal "Male", rails.gender
        assert_equal 0, rails.wowarmory_gender_id
        assert_equal 2, rails.wowarmory_class_id
        assert_equal "Baelgun", rails.realm
        assert_equal "Shadowburn", rails.battle_group
        assert_equal "Special Circumstances", rails.guild
        assert_equal "r=Baelgun&gn=Special+Circumstances", rails.guild_url
        assert_equal "Paladin", rails.wow_class_name
        assert_equal "Protection", rails.primary_spec
      end
    end
  end
end
