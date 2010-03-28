require File.dirname(__FILE__) + '/../test_helper'

class CharacterTest < ActiveSupport::TestCase
  context "find_by_name_or_create_from_wowarmory" do
    should "find character by name and realm" do
      assert_difference "Character.count" do
        rails = Character.find_by_name_and_realm_or_create_from_wowarmory("Rails", "Baelgun")
        assert_equal "Rails", rails.name
        assert_equal "Baelgun", rails.realm
      end
    end
    
    should_eventually "re-import/reparse a character if they already exist"
    should_eventually "display a unable to fetch the latest data for your character, wow armory may be down"
  end
end