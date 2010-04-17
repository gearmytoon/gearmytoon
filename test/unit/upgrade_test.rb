require File.dirname(__FILE__) + '/../test_helper'

class UpgradeTest < ActiveSupport::TestCase
  context "new_item_source_type" do
    should "be emblem for emblem_sources" do
      upgrade = Upgrade.new(EmblemSource.new,nil,nil)
      assert_equal "emblem", upgrade.new_item_source_type
    end
    should "be honor for honor_sources" do
      upgrade = Upgrade.new(HonorSource.new,nil,nil)
      assert_equal "honor", upgrade.new_item_source_type
    end
    should "be arena for arena_sources" do
      upgrade = Upgrade.new(ArenaSource.new,nil,nil)
      assert_equal "arena", upgrade.new_item_source_type
    end
    should "be dropped for dropped_sources" do
      upgrade = Upgrade.new(DroppedSource.new,nil,nil)
      assert_equal "dropped", upgrade.new_item_source_type
    end
  end
end
