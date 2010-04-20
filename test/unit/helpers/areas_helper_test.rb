require File.dirname(__FILE__) + '/../../test_helper'

class AreasHelperTest < ActionView::TestCase
  context "wowhead_area_link" do
    should "link to a area" do
      dungeon = Factory(:dungeon, :name => "Foo", :difficulty => "h")
      tag = wowhead_area_link(dungeon)
      assert_equal "<a href=\"http://www.wowhead.com/?zone=#{dungeon.wowarmory_area_id}\">Heroic Foo</a>", tag
    end
  end
end
