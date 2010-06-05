require File.dirname(__FILE__) + '/../test_helper'

class StringExtensionTest < ActiveSupport::TestCase
  context "extract_bonuses" do

    should "return empty hash if empty string given" do
      assert_equal({}, "".extract_bonuses)
    end

    should "extract parry and stamina" do
      assert_equal({:parry => 8, :stamina => 12}, "+8 Parry Rating and +12 Stamina".extract_bonuses)
    end
    
    should "extract spell power and resil" do
      assert_equal({:resilience => 10, :spell_power => 12}, "+12 Spell Power and +10 Resilience Rating".extract_bonuses)
    end

    should "extract crit rating" do
      assert_equal({:agility => 10, :crit => 11}, "+10 Agility and +11 Critical Strike Rating".extract_bonuses)
    end

    should "extract old school mp5" do
      assert_equal({:intellect => 5, :mana_regen => 3}, "+5 Intellect and +3 Mana every 5 seconds".extract_bonuses)
    end

    should "extract mp5" do
      assert_equal({:intellect => 10, :mana_regen => 5}, "+10 Intellect and +5 Mana every 5 seconds".extract_bonuses)
    end

    should "extract attack power" do
      assert_equal({:attack_power => 16}, "+16 Attack Power".extract_bonuses)
    end
  end
end
