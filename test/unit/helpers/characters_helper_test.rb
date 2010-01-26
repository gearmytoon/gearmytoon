require File.dirname(__FILE__) + '/../../test_helper'
require 'ostruct'

class CharactersHelperTest < ActionView::TestCase
  should "generate a link to wowhead for the item" do
    item = OpenStruct.new(:icon => "http://www.wowarmory.com/some_item_thumb", :item_id => 4864, :name => "Minshina's Skull")
    tag = wowhead_item_image_link(item)
    assert_equal "<a href=\"http://www.wowhead.com/?item=4864\"><img alt=\"Minshina's Skull\" border=\"0\" src=\"http://www.wowarmory.com/some_item_thumb\" /></a>", tag
  end
end
