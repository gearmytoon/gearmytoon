require File.dirname(__FILE__) + '/../test_helper'

class GemItemTest < ActiveSupport::TestCase
  context "usable_in_slot" do
    setup do
      @prismatic = Factory(:prismatic_gem)
      @red = Factory(:red_gem)
      @orange = Factory(:orange_gem)
      @yellow = Factory(:yellow_gem)
      @green = Factory(:green_gem)
      @blue = Factory(:blue_gem)
      @purple = Factory(:purple_gem)
      @meta = Factory(:meta_gem)
    end

    should "not find gems that are BOP" do
      Factory(:meta_gem, :bonding => Item::BOP)
      usable_gems = GemItem.usable_in_slot("Meta")
      assert_equivalent([@meta], usable_gems, :gem_color)
    end

    should "find gems usable in red slots" do
      usable_gems = GemItem.usable_in_slot("Red")
      assert_equivalent([@red, @prismatic, @orange, @purple], usable_gems, :gem_color)
    end

    should "find gems usable in any slots" do
      usable_gems = GemItem.usable_in_slot("Any")
      assert_equivalent([@red, @prismatic, @orange, @purple, @green, @yellow, @blue], usable_gems, :gem_color)
    end

    should "find gems usable in yellow slots" do
      usable_gems = GemItem.usable_in_slot("Yellow")
      assert_equivalent([@yellow, @prismatic, @orange, @green], usable_gems, :gem_color)
    end

    should "find gems usable in blue slots" do
      usable_gems = GemItem.usable_in_slot("Blue")
      assert_equivalent([@blue, @prismatic, @green, @purple], usable_gems, :gem_color)
    end

    should "find gems usable in meta slots" do
      usable_gems = GemItem.usable_in_slot("Meta")
      assert_equivalent([@meta], usable_gems, :gem_color)
    end
  end
  
end
