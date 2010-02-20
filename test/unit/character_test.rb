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
  
  context "dps_for" do
    should "know the relative dps for a item" do
      character = Factory(:character)
      assert_equal 191.6, character.dps_for(Factory(:item, :bonuses => {:attack_power => 130, :agility => 89, :hit => 47, :stamina => 76}))
    end
  end

  #this should go to a hunter dps forumla class eventually, it's own model
  context "convert_bonuses_to_dps" do
    should "attack power should be worth 0.5 dps" do
      character = Factory(:character)
      assert_equal 65.0, character.convert_bonuses_to_dps(:attack_power => 130)
    end

    should "agility should be worth 1 dps" do
      character = Factory(:character)
      assert_equal 89.0, character.convert_bonuses_to_dps(:agility => 89)
    end

    should "hit should be worth 0.8 dps" do
      character = Factory(:character)
      assert_equal 40.0, character.convert_bonuses_to_dps(:hit => 50)
    end

    should "haste should be worth 0.7 dps" do
      character = Factory(:character)
      assert_equal 35.0, character.convert_bonuses_to_dps(:haste => 50)
    end

    should "crit should be worth 0.75 dps" do
      character = Factory(:character)
      assert_equal 37.5, character.convert_bonuses_to_dps(:crit => 50)
    end

    should "armor_penetration should be worth 1.1 dps" do
      character = Factory(:character)
      assert_equal 55, character.convert_bonuses_to_dps(:armor_penetration => 50).to_i
    end

  end

end
