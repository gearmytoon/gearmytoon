require File.dirname(__FILE__) + '/../test_helper'

class CharacterRefreshTest < ActiveSupport::TestCase
  context "refreshing a toon" do
    should "mark a toon as found" do
      character_refresh = Factory(:character_refresh)
      character_refresh.found!
      assert_equal "done", character_refresh.status
      assert_equal "found", character_refresh.character.status
    end
    should "mark a toon as does not exist" do
      character_refresh = Factory(:character_refresh)
      character_refresh.not_found!
      assert_equal "done", character_refresh.status
      assert_equal "does_not_exist", character_refresh.character.status
    end
  end
end
