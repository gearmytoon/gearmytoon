require File.dirname(__FILE__) + '/../test_helper'

class GemItemTest < ActiveSupport::TestCase
  context "usable_in_slot" do
    setup do
      @prismatic = Factory(:gem, :gem_color => "Prismatic")
      @red = Factory(:gem, :gem_color => "Red")
      @orange = Factory(:gem, :gem_color => "Orange")
      @yellow = Factory(:gem, :gem_color => "Yellow")
      @green = Factory(:gem, :gem_color => "Green")
      @blue = Factory(:gem, :gem_color => "Blue")
      @purple = Factory(:gem, :gem_color => "Purple")
      @meta = Factory(:gem, :gem_color => "Meta")
    end

    should "find gems usable in red slots" do
      usable_gems = GemItem.usable_in_slot("Red")
      assert_equivalent([@red, @prismatic, @orange, @purple], usable_gems)
    end
    should "find gems usable in yellow slots" do
      usable_gems = GemItem.usable_in_slot("Yellow")
      assert_equivalent([@yellow, @prismatic, @orange, @green], usable_gems)
    end

    should "find gems usable in blue slots" do
      usable_gems = GemItem.usable_in_slot("Blue")
      assert_equivalent([@blue, @prismatic, @green, @purple], usable_gems)
    end

    should "find gems usable in meta slots" do
      usable_gems = GemItem.usable_in_slot("Meta")
      assert_equivalent([@meta], usable_gems)
    end
  end
  
  def assert_equivalent(expected, actual)
    assert expected.equivalent?(actual), "#{actual.map(&:gem_color).join(",")} did not match expected: #{expected.map(&:gem_color).join(",")}"
  end
  
end
