require File.dirname(__FILE__) + '/../test_helper'

class AreaTest < ActiveSupport::TestCase
  context "players" do
    should "be set to 10 on create if the raid has 10 in its name" do
      area = Area.create!(:name => "FooBar (10)")
      assert_equal 10, area.players
    end
    should "be set to 25 on create if the raid has 25 in its name" do
      area = Area.create!(:name => "FooBar (25)")
      assert_equal 25, area.players
    end

    should "be set to 25 on create if the raid has 25 in its name and is normal mode" do
      area = Area.create!(:name => "FooBar (25)", :difficulty => 'n')
      assert_equal 25, area.players
    end

    should "be set to 25 on create if the raid has no numeric value in its name and is heroic mode" do
      area = Area.create!(:name => "FooBar", :difficulty => 'h')
      assert_equal 25, area.players
    end

    should "be set to 10 on create if the raid has no numeric value in its name and is normal mode" do
      area = Area.create!(:name => "FooBar", :difficulty => 'n')
      assert_equal 10, area.players
    end
  end

  context "associations" do
    should "have many items dropped in through item source" do
      item = Factory(:item_from_heroic_dungeon)
      Factory(:item_from_emblem_of_triumph)
      assert_equal [item], Area.first.items_dropped_in
    end
  end

  context "raids" do
    should "find all the raids" do
      dungeon = Factory(:dungeon)
      raid = Factory(:raid)
      assert_equal [raid], Area.raids
    end
  end

  context "dungeons" do
    should "find all the dungeons" do
      dungeon = Factory(:dungeon)
      raid = Factory(:raid)
      assert_equal [dungeon], Area.dungeons
    end
  end

  context "raids_10" do
    should "find all the dungeons" do
      Factory(:raid_25)
      raid = Factory(:raid_10)
      assert_equal [raid], Area.raids_10
    end
  end

  context "raids_25" do
    should "find all the dungeons" do
      Factory(:raid_10)
      raid = Factory(:raid_25)
      assert_equal [raid], Area.raids_25
    end
  end

  context "full_name" do
    should "convert H to heroic" do
      raid = Factory(:raid, :name => "Foo", :difficulty => "h")
      assert_equal "Heroic Foo", raid.full_name
    end
    should "convert n to empty string" do
      raid = Factory(:raid, :name => "foo", :difficulty => "n")
      assert_equal "foo", raid.full_name
    end
  end
end
