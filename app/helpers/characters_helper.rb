module CharactersHelper
  def wowhead_item_image_link(item)
    link_to image_tag(item.icon, :alt => item.name, :border => 0), "http://www.wowhead.com/?item=#{item.item_id}"
  end
  
  def stylized_item_name(item)
    content_tag(:span, item.name, :class => WowHelpers.quality_adjective_for(item))
  end
end
