require File.dirname(__FILE__) + '/../test_helper'

class AreaTest < ActiveSupport::TestCase
  context "associations" do
    should_have_many :items_dropped_in
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

  context "full name" do
    should "contain the difficulty and the name" do
      raid = Factory(:raid, :name => "foo", :difficulty => "bar")
      assert_equal "bar foo", raid.full_name
    end
  end
end
