require File.dirname(__FILE__) + '/../test_helper'

class CharacterJobTest < ActiveSupport::TestCase

  should "import a characters items" do
    character_refresh = Factory(:character_refresh, :character => Factory(:character, :name => "Merb", :realm => "Baelgun"))
    assert_difference "Item.count", 23 do
      CharacterJob.perform(character_refresh.id)
    end
    assert_equal "found", character_refresh.character.reload.status
    assert_equal "done", character_refresh.reload.status
  end
  
  should "know if the character does not exist" do
    character_refresh = Factory(:character_refresh, :character => Factory(:character, :name => "zzzzzzzzzzzzzMerb", :realm => "Baelgun"))
    CharacterJob.perform(character_refresh.id)
    assert_equal "does_not_exist", character_refresh.character.reload.status
    assert_equal "done", character_refresh.reload.status
  end
  
end
