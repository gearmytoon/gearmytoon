require File.dirname(__FILE__) + '/../test_helper'

class WowClassTest < ActiveSupport::TestCase
  context "associations" do
    should_belong_to :primary_armor_type
    
    should "serialize stat_multipliers" do
      expected_stat_multipliers = {:a => 1}
      wow_class = Factory(:wow_class, :stat_multipliers => expected_stat_multipliers)
      assert_equal expected_stat_multipliers, wow_class.reload.stat_multipliers
    end
    
  end

  context "equippable_items" do
    should "find upgrades of the same armor type" do
      rogue = WowClass.create!(WowClass::WowClassConstants::Rogue)
      plate_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :inventory_type => 2, :armor_type => ArmorType.Plate)
      leather_upgrade = Factory(:item_from_emblem_of_frost, :bonuses => {:attack_power => 500.0}, :inventory_type => 2, :armor_type => ArmorType.Leather)
      assert_equal 1, rogue.equippable_items.size
      assert_equal leather_upgrade, rogue.equippable_items.first
    end
  end


  #this should go to a hunter dps forumla class eventually, it's own model
  context "convert_bonuses_to_dps" do
    should "attack power should be worth 0.5 dps" do
      assert_equal 65.0, Factory(:a_rogue).dps_for(:attack_power => 130)
    end

    should "agility should be worth 1 dps" do
      assert_equal 89.0, Factory(:a_rogue).dps_for(:agility => 89)
    end

    should "hit should be worth 0.8 dps" do
      assert_equal 40.0, Factory(:a_rogue).dps_for(:hit => 50)
    end

    should "haste should be worth 0.7 dps" do
      assert_equal 35.0, Factory(:a_rogue).dps_for(:haste => 50)
    end

    should "crit should be worth 0.75 dps" do
      assert_equal 37.5, Factory(:a_rogue).dps_for(:crit => 50)
    end

    should "armor_penetration should be worth 1.1 dps" do
      assert_equal 55, Factory(:a_rogue).dps_for(:armor_penetration => 50).to_i
    end

  end

  context "dps" do
    should "know the relative dps for a item" do
      assert_equal 191.6, Factory(:a_rogue).dps_for(:attack_power => 130, :agility => 89, :hit => 47, :stamina => 76)
    end
  end


end
