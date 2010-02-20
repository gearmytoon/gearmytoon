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
  
end
