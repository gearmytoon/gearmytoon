require File.dirname(__FILE__) + '/../../test_helper'

class AreasHelperTest < ActionView::TestCase
  context "wowhead_area_link" do
    should "link to a area" do
      dungeon = Factory(:dungeon, :name => "foo", :difficulty => "bar")
      tag = wowhead_area_link(dungeon)
      assert_equal "<a href=\"http://www.wowhead.com/?zone=#{dungeon.wowarmory_area_id}\">bar foo</a>", tag
    end
  end
end
