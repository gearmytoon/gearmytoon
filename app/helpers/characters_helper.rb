module CharactersHelper
  def wowhead_item_image_link(item)
    link_to image_tag(item.icon, :alt => item.name, :border => 0), "http://www.wowhead.com/?item=#{item.item_id}"
  end
end
