require File.dirname(__FILE__) + '/../test_helper'

class CharacterTest < ActiveSupport::TestCase
  context "associations" do
    should_have_many :equipped_items
    should_have_many :character_items
    should "have many equipped items through character_items" do
      character_item = Factory(:character_item)
      assert_equal [character_item.item], character_item.character.equipped_items
    end
  end

  context "top_3_frost_upgrades" do
    should "find a characters top 3 upgrades from frost badges" do
      character = Factory(:character)
      upgrades = (1..3).map {Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0})}
      assert_equal upgrades, character.top_3_frost_upgrades
    end
  end
end
