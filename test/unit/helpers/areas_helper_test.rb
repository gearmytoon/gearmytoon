require 'test_helper'

class AreasHelperTest < ActionView::TestCase
  context "wowhead_area_link" do
    should "link to a area" do
      area = Factory(:area)
      tag = wowhead_area_link(area)
      assert_equal "<a href=\"http://www.wowhead.com/?zone=#{area.wowarmory_id}\">#{area.name}</a>", tag
    end
  end
end
