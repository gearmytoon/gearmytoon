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

  context "raids" do
    should "find all the raids" do
      dungeon = Factory(:dungeon)
      raid = Factory(:raid)
      assert Area.raids.include?(raid)
      assert_false Area.raids.include?(dungeon)
    end
  end

  context "dungeons" do
    should "find all the dungeons" do
      dungeon = Factory(:dungeon)
      raid = Factory(:raid)
      assert Area.dungeons.include?(dungeon)
      assert_false Area.dungeons.include?(raid)
    end
  end

  context "raids_10" do
    should "find all the dungeons" do
      raid_25 = Factory(:raid_25)
      raid_10 = Factory(:raid_10)
      assert Area.raids_10.include?(raid_10)
      assert_false Area.raids_10.include?(raid_25)
    end
  end

  context "raids_25" do
    should "find all the dungeons" do
      raid_10 = Factory(:raid_10)
      raid_25 = Factory(:raid_25)
      assert Area.raids_25.include?(raid_25)
      assert_false Area.raids_25.include?(raid_10)
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
