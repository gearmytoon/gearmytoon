require File.dirname(__FILE__) + '/../test_helper'

class AreaTest < ActiveSupport::TestCase

  context "dungeons" do
    should "find all the dungeons" do
      dungeon = Factory(:dungeon)
      raid = Factory(:raid)
      assert_equal [dungeon], Area.dungeons
    end
  end

  context "raids" do
    should "find all the dungeons" do
      dungeon = Factory(:dungeon)
      raid = Factory(:raid)
      assert_equal [raid], Area.raids
    end
  end

end
