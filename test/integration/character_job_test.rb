require File.dirname(__FILE__) + '/../test_helper'

class CharacterJobTest < ActiveSupport::TestCase

  should "import a characters items" do
    character_refresh = Factory(:character_refresh, :character => Factory(:character, :name => "Merb", :realm => "Baelgun"))
    assert_difference "Item.count", 18 do
      CharacterJob.perform(character_refresh.id)
    end
    assert_equal "found", character_refresh.character.reload.status
  end
  
  should "know if the character does not exist" do
    character_refresh = Factory(:character_refresh, :character => Factory(:character, :name => "zzzzzzzzzzzzzMerb", :realm => "Baelgun"))
    CharacterJob.perform(character_refresh.id)
    assert_equal "does_not_exist", character_refresh.character.reload.status
  end
end
# 
# #/character_refresh/:id.json {:status => @character_refresh.status}
# 
# #character_refresh :id, :character_id, :status (:new, :done)
# 
# #character :id, ..., :status (:new, :unsupported, :found, :does_not_exist)
# 
# <%= render "characters/#{@character.status}" %>