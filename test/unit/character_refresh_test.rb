require File.dirname(__FILE__) + '/../test_helper'

class CharacterRefreshTest < ActiveSupport::TestCase
  should "find active refreshes" do
    character_refresh = Factory(:character_refresh)
    assert_equal [character_refresh], CharacterRefresh.active
    character_refresh.found!
    assert_equal [], CharacterRefresh.active
  end

  should "find recent refreshes" do
    freeze_time(10.minutes.ago)
    character_refresh = Factory(:character_refresh)
    character = character_refresh.character
    assert_equal [character_refresh], character.character_refreshes.recent
    freeze_time(10.minutes.from_now)
    assert_equal [], character.reload.character_refreshes.recent
  end
  
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
