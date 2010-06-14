require File.dirname(__FILE__) + '/../test_helper'

class GemItemTest < ActiveSupport::TestCase
  context "usable_in_slot" do
    setup do
      @prismatic = Factory(:prismatic_gem)
      @red = Factory(:red_gem)
      @yellow = Factory(:yellow_gem)
      @blue = Factory(:blue_gem)
      @meta = Factory(:meta_gem)
    end

    should "not find gems that are BOP" do
      Factory(:meta_gem, :bonding => Item::BOP)
      actual = GemItem.with_color("Meta")
      assert_equal([@meta], actual)
    end

    should "find gems usable in red slots" do
      actual = GemItem.with_color("Red")
      assert_equal([@red], actual)
    end

    #TODO, move to character test
    should_eventually "find gems usable in any slots" do
      usable_gems = GemItem.with_color("Any")
      assert_equivalent([@red, @prismatic, @orange, @purple, @green, @yellow, @blue], usable_gems, :gem_color)
    end

    should "find gems usable in yellow slots" do
      actual = GemItem.with_color("Yellow")
      assert_equal([@yellow], actual)
    end

    should "find gems usable in blue slots" do
      actual = GemItem.with_color("Blue")
      assert_equal([@blue], actual)
    end

  end
  
end
