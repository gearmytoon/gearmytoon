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
  end
end