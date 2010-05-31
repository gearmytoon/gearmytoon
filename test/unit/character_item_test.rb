require File.dirname(__FILE__) + '/../test_helper'

class CharacterItemTest < ActiveSupport::TestCase
  should "know items equipped in slot" do
    character_item = Factory(:character_item, :item => Factory(:ring))
    Factory(:character_item, :item => Factory(:polearm), :character => character_item.character)
    assert_equal [character_item], CharacterItem.equipped_on("Finger")
  end
end
