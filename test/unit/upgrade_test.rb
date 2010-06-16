require File.dirname(__FILE__) + '/../test_helper'

class UpgradeTest < ActiveSupport::TestCase
  context "new_item_source_type" do
    should "be emblem for emblem_sources" do
      upgrade = Factory.build(:upgrade, :new_item_source => EmblemSource.new)
      assert_equal "emblem", upgrade.new_item_source_type
    end
    should "be honor for honor_sources" do
      upgrade = Factory.build(:upgrade, :new_item_source => HonorSource.new)
      assert_equal "honor", upgrade.new_item_source_type
    end
    should "be arena for arena_sources" do
      upgrade = Factory.build(:upgrade, :new_item_source => ArenaSource.new)
      assert_equal "arena", upgrade.new_item_source_type
    end
    should "be dropped for dropped_sources" do
      upgrade = Factory.build(:upgrade, :new_item_source => DroppedSource.new)
      assert_equal "dropped", upgrade.new_item_source_type
    end
  end
  
  context "kind_of_change" do
    should "know if it is an upgrade" do
      upgrade = Factory.build(:upgrade, :dps_change => 1)
      assert_equal "upgrade", upgrade.kind_of_change
    end
    should "know if it is an downgrade" do
      upgrade = Factory.build(:upgrade, :dps_change => -1)
      assert_equal "downgrade", upgrade.kind_of_change
    end
  end
  
  context "stat_change_between" do

    should "know that the item will bring the player to the hit cap" do
      character = Factory(:character, :total_item_bonuses => {:hit => 251})
      old_item = Factory(:character_item, :item => Factory(:item, :bonuses => {:agility => 10.0, :hit => 251, :attack_power => 20.0}), :character => character)
      new_item = Factory(:item, :bonuses => {:agility => 10.0, :hit => 300, :attack_power => 20.0}, :gem_sockets => ["Yellow"])
      Factory(:yellow_gem, :bonuses => {:hit => 20})
      expected_gem = Factory(:orange_gem, :bonuses => {:agility => 1})
      upgrade = Factory(:upgrade, :character => character, :old_character_item => old_item, :new_item_source => Factory(:frost_emblem_source, :item => new_item))
      assert_equal expected_gem, upgrade.gem_one
    end

    should "take hard caps into account with gem stats" do
      character = Factory(:character, :total_item_bonuses => {})
      old_item = Factory(:character_item, :character => character)
      new_item = Factory(:item, :gem_sockets => ["Yellow"])
      Factory(:yellow_gem, :bonuses => {:hit => 1000})
      expected_gem = Factory(:orange_gem, :bonuses => {:agility => 800})
      upgrade = Factory(:upgrade, :character => character, :old_character_item => old_item, :new_item_source => Factory(:frost_emblem_source, :item => new_item))
      assert_equal expected_gem, upgrade.gem_one
    end
    
    should "know you can't swap meta gems out for anything else" do
      red_gem = Factory(:red_gem, :bonuses => {:agility => 20})
      meta_gem = Factory(:meta_gem, :bonuses => {:agility => 2})
      Factory(:purple_gem, :bonuses => {:agility => 10})
      character = Factory(:a_hunter)
      item = Factory(:item, :gem_sockets => ["Meta", "Blue"], :socket_bonuses => {:agility => 1})
      character_item = Factory(:character_item, :item => item, :character => character)
      new_item_source = Factory(:frost_emblem_source, :item => character_item.item)
      upgrade = Factory(:upgrade, :old_character_item => character_item, :character => character, :new_item_source => new_item_source)
      assert_equal meta_gem, upgrade.reload.gem_one
      assert_equal red_gem, upgrade.reload.gem_two
    end

    should "know not to break the gem set bonus if the set bonus is big enough" do
      Factory(:red_gem, :bonuses => {:agility => 20})
      best_gem_with_socket_bonus = Factory(:purple_gem, :bonuses => {:agility => 19})
      character = Factory(:a_hunter)
      item = Factory(:item, :gem_sockets => ["Blue"], :socket_bonuses => {:hit => 200})
      character_item = Factory(:character_item, :character => character)
      new_item_source = Factory(:frost_emblem_source, :item => item)
      upgrade = Factory(:upgrade, :old_character_item => character_item, :character => character, :new_item_source => new_item_source)
      assert_equal best_gem_with_socket_bonus, upgrade.reload.gem_one
    end

    should "know to break the gem set bonus if the set bonus is big enough" do
      best_gem = Factory(:red_gem, :bonuses => {:agility => 20})
      Factory(:purple_gem, :bonuses => {:agility => 10})
      character = Factory(:a_hunter)
      item = Factory(:item, :gem_sockets => ["Blue"], :socket_bonuses => {:agility => 1})
      character_item = Factory(:character_item, :item => item, :character => character)
      new_item_source = Factory(:frost_emblem_source, :item => character_item.item)
      upgrade = Factory(:upgrade, :old_character_item => character_item, :character => character, :new_item_source => new_item_source)
      assert_equal best_gem, upgrade.reload.gem_one
    end

    should "find the best combo of gems if you are just about to get to the hit cap" do
      orange_gem = Factory(:orange_gem, :bonuses => {:agility => 10, :hit => 10})
      purple_gem = Factory(:purple_gem, :bonuses => {:agility => 11})
      character = Factory(:a_hunter, :total_item_bonuses => {:hit => 253})
      item = Factory(:item, :gem_sockets => ["Blue", "Yellow"], :socket_bonuses => {:agility => 1})
      character_item = Factory(:character_item, :item => item, :character => character)
      new_item_source = Factory(:frost_emblem_source, :item => character_item.item)
      upgrade = Factory(:upgrade, :old_character_item => character_item, :character => character, :new_item_source => new_item_source)
      assert_equal [purple_gem.id, orange_gem.id], upgrade.gems.map(&:id)
    end

    should "know the change in stats including gems" do
      gem_item = Factory(:gem, :bonuses => {:agility => 30})
      character = Factory(:a_hunter)
      item = Factory(:item, :gem_sockets => ["Red"])
      character_item = Factory(:character_item, :item => item, :character => character, :gem_one => gem_item)
      new_item_source = Factory(:frost_emblem_source, :item => character_item.item)
      #gem_item will be found in the after_create
      upgrade = Factory(:upgrade, :old_character_item => character_item, :character => character, :new_item_source => new_item_source)
      assert_equal 0.0, upgrade.reload.dps_change
      assert_equal({:agility=>0, :attack_power=>0.0}, upgrade.reload.bonus_changes)
    end
    should "know the change in stats between two items" do
      character = Factory(:a_hunter)
      old_item = Factory(:character_item, :item => Factory(:item, :bonuses => {:agility => 10.0, :attack_power => 20.0}), :character => character)
      new_item = Factory(:item, :bonuses => {:agility => 20.0, :attack_power => 10.0})
      upgrade = Factory(:upgrade, :old_character_item => old_item, :new_item_source => Factory(:frost_emblem_source, :item => new_item), :character => character)
      expected_result = {:agility => 10.0, :attack_power => -10.0}
      assert_equal expected_result, upgrade.bonus_changes
    end

    should "know the change in stats between two items incuding new gems" do
      character = Factory(:a_hunter)
      old_item = Factory(:character_item, :item => Factory(:item, :bonuses => {:agility => 10.0, :attack_power => 20.0}), :character => character)
      new_item = Factory(:item, :bonuses => {:agility => 20.0, :attack_power => 10.0})
      upgrade = Factory(:upgrade, :old_character_item => old_item, :character => character, :new_item_source => Factory(:frost_emblem_source, :item => new_item),
      :gem_one => Factory(:gem, :bonuses => {:attack_power => 3}), :gem_two => Factory(:gem, :bonuses => {:intellect => 3}), :gem_three => Factory(:gem, :bonuses => {:agility => 3}))
      expected_result = {:agility => 13.0, :attack_power => -7.0, :intellect => 3}
      assert_equal expected_result, upgrade.bonus_changes
    end

    should "know the change in stats between two items including gems" do
      character = Factory(:a_hunter)
      old_item = Factory(:character_item, :item => Factory(:item, :bonuses => {:agility => 10.0, :attack_power => 20.0}), :character => character, :gem_one => Factory(:gem, :bonuses => {:agility => 3}), :gem_two => Factory(:gem, :bonuses => {:intellect => 5}))
      new_item = Factory(:item, :bonuses => {:agility => 20.0, :attack_power => 10.0})
      upgrade = Factory(:upgrade, :old_character_item => old_item, :new_item_source => Factory(:frost_emblem_source, :item => new_item), :character => character)
      expected_result = {:agility => 7.0, :attack_power => -10.0, :intellect => -5}
      assert_equal expected_result, upgrade.bonus_changes
    end

    should "know the change in stats between two items after the hit cap" do
      character = Factory(:character, :total_item_bonuses => {:hit => 251})
      old_item = Factory(:character_item, :item => Factory(:item, :bonuses => {:agility => 10.0, :hit => 251, :attack_power => 20.0}), :character => character)
      new_item = Factory(:item, :bonuses => {:agility => 10.0, :hit => 300, :attack_power => 10.0})
      upgrade = Factory(:upgrade, :character => character, :old_character_item => old_item, :new_item_source => Factory(:frost_emblem_source, :item => new_item))
      expected_result = {:hit => 12.0, :agility=>0.0, :attack_power => -10.0}
      assert_equal expected_result, upgrade.bonus_changes
    end

    should "know the change in stats between two items after the hit cap when the character is way above the hit cap" do
      character = Factory(:character, :total_item_bonuses => {:hit => 300})
      expected_result = {:hit => 0.0, :agility=>0.0, :attack_power => -10.0}
      old_item = Factory(:character_item, :item => Factory(:item, :bonuses => {:agility => 10.0, :hit => 22, :attack_power => 20.0}), :character => character)
      new_item = Factory(:item, :bonuses => {:agility => 10.0, :hit => 0, :attack_power => 10.0})
      upgrade = Factory(:upgrade, :character => character, :old_character_item => old_item, :new_item_source => Factory(:frost_emblem_source, :item => new_item))
      assert_equal expected_result, upgrade.bonus_changes
    end

    should "be okay if the total hit can't be imported for a character" do
      character = Factory(:character, :total_item_bonuses => {})
      expected_result = {:hit => -22.0, :agility=>0.0, :attack_power => -10.0}
      old_item = Factory(:character_item, :item => Factory(:item, :bonuses => {:agility => 10.0, :hit => 22, :attack_power => 20.0}), :character => character)
      new_item = Factory(:item, :bonuses => {:agility => 10.0, :hit => 0, :attack_power => 10.0})
      upgrade = Factory(:upgrade, :character => character, :old_character_item => old_item, :new_item_source => Factory(:frost_emblem_source, :item => new_item))
      assert_equal expected_result, upgrade.bonus_changes
    end

  end

  context "find_best_gem" do
    should "find the best gem" do
      character = Factory(:character, :total_item_bonuses => {})
      Factory(:gem, :bonuses => {:agility => 99})
      best_gem = Factory(:gem, :bonuses => {:agility => 100})
      new_item = Factory(:item_with_3_gem_sockets, :gem_sockets => ["Red", "Red", "Red"])
      upgrade = Factory(:upgrade, :character => character, :new_item_source => Factory(:frost_emblem_source, :item => new_item))
      assert_equal best_gem, upgrade.gem_one
      assert_equal best_gem, upgrade.gem_two
      assert_equal best_gem, upgrade.gem_three
    end

    should "not find meta gems for non meta slots" do
      character = Factory(:character, :total_item_bonuses => {})
      best_gem = Factory(:gem, :bonuses => {:agility => 100}, :gem_color => "Meta")
      worst = Factory(:gem, :bonuses => {:agility => 1}, :gem_color => "Red")
      new_item = Factory(:item, :gem_sockets => ["Red"])
      upgrade = Factory(:upgrade, :character => character, :new_item_source => Factory(:frost_emblem_source, :item => new_item))
      assert_equal worst, upgrade.gem_one
      assert_equal nil, upgrade.gem_two
      assert_equal nil, upgrade.gem_three
    end

    should "only find gems if the item has enough sockets for them" do
      character = Factory(:character, :total_item_bonuses => {})
      best_gem = Factory(:gem, :bonuses => {:agility => 100})
      new_item = Factory(:item, :gem_sockets => ["Red"])
      upgrade = Factory(:upgrade, :character => character, :new_item_source => Factory(:frost_emblem_source, :item => new_item))
      assert_equal best_gem, upgrade.gem_one
      assert_equal nil, upgrade.gem_two
      assert_equal nil, upgrade.gem_three
    end

  end

  context "change_in_stats" do
    should "return the change in stats between two items" do
      character = Factory(:character, :total_item_bonuses => {})
      old_item = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0, :spell_power => 45, :stamina => 20}), :character => character)
      new_item = Factory(:item, :bonuses => {:attack_power => 200.0, :stamina => 10.0, :dodge => 20})
      upgrade = Factory(:upgrade, :character => character, :old_character_item => old_item, :new_item_source => Factory(:frost_emblem_source, :item => new_item))
      expected_difference = {:attack_power => 100.0, :stamina => -10.0, :spell_power => -45.0, :dodge => 20}
      assert_equal expected_difference, upgrade.change_in_stats
    end
  end
  
end
