require File.dirname(__FILE__) + '/../../test_helper'
require 'ostruct'

class CharactersHelperTest < ActionView::TestCase

  context "wowhead_item_image_link" do
    should "generate a link to wowhead for the item" do
      item = OpenStruct.new(:icon => "http://www.wowarmory.com/some_item_thumb", :item_id => 4864, :name => "Minshina's Skull")
      tag = wowhead_item_image_link(item)
      assert_equal "<a href=\"http://www.wowhead.com/?item=4864\"><img alt=\"Minshina's Skull\" border=\"0\" src=\"http://www.wowarmory.com/some_item_thumb\" /></a>", tag
    end
  end
  
  context "wowhead_npc_link" do
    should "generate a link to wowhead for the npc" do
      tag = wowhead_npc_link(stub_everything(:name => "Bronjahm", :id => 36497))
      assert_equal "<a href=\"http://www.wowhead.com/?npc=36497\">Bronjahm</a>", tag
      tag = wowhead_npc_link(stub_everything(:name => "Kong", :id => 2))
      assert_equal "<a href=\"http://www.wowhead.com/?npc=2\">Kong</a>", tag
    end
  end
  
  context "stylized_item_name" do
    should "provide a span with the item name and its quality" do
      item = OpenStruct.new(:quality => 4, :name => "Minshina's Skull")
      tag = stylized_item_name(item)
      assert_equal "<span class=\"epic\">Minshina's Skull</span>", tag
    end
  end
  
end
