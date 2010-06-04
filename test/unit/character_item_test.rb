require File.dirname(__FILE__) + '/../test_helper'

class CharacterItemTest < ActiveSupport::TestCase
  should "know items equipped in slot" do
    character_item = Factory(:character_item, :item => Factory(:ring))
    Factory(:character_item, :item => Factory(:polearm), :character => character_item.character)
    assert_equal [character_item], CharacterItem.equipped_on("Finger")
  end
  
  should "combine the dps of a item and the gems it has" do
    character_item = Factory(:character_item, :item => Factory(:polearm, :bonuses => {:agility => 10, :spirit => 1}), :gem_one => Factory(:red_gem, :bonuses => {:agility => 5, :stamina => 1}))
    assert_equal({:agility => 15, :stamina => 1, :spirit => 1}, character_item.bonuses)
  end
end
