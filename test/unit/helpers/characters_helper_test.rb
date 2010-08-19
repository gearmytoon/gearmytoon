require File.dirname(__FILE__) + '/../../test_helper'
require 'ostruct'

class CharactersHelperTest < ActionView::TestCase

  context "item_image_link" do
    should "generate a link to wowhead for the item" do
      item = Factory(:item, :name => "Minshina's Skull", :icon => "some_item_thumb")
      tag = item_image_link(item)
      assert_equal "<a href=\"/items/#{item.wowarmory_item_id}\" class=\"with_tooltip image_item_link\"><img alt=\"Minshina's Skull\" border=\"0\" class=\"item_icon\" src=\"http://wowarmory.com/wow-icons/_images/43x43/some_item_thumb.png\" /></a>", tag
    end
  end
  
  context "character_icon" do
    should "assume level 80 and be based on the gender, race and klass_id of the character" do
      character = OpenStruct.new(:name => "Merb", :wowarmory_gender_id => 0, :wowarmory_race_id => 8, :wowarmory_class_id => 3)
      expected = "<img alt=\"Merb\" src=\"http://www.wowarmory.com/_images/portraits/wow-80/0-8-3.gif\" />"
      assert_equal expected, character_icon(character)
    end
  end

  context "stylized_item_name" do
    should "provide a span with the item name and its quality" do
      item = Factory(:item, :name => "Minshina's Skull")
      tag = stylized_item_name(item)
      assert_equal "<a href=\"/items/#{item.wowarmory_item_id}\" class=\"epic wow_item with_tooltip\">Minshina's Skull</a>", tag
    end
  end
end
