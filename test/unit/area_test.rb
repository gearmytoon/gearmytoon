require File.dirname(__FILE__) + '/../test_helper'

class AreaTest < ActiveSupport::TestCase
  should "set the area name" do
    Area.destroy_all
    Area.create(:wowarmory_id => 206)
    assert_equal "Utgarde Keep", Area.first.name
  end
  
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
