module CharactersHelper
  
  def item_image_link(item)
    link_to item_icon(item), item_path(item), :class => "with_tooltip image_item_link"
  end

  def character_icon(character)
    image_tag "http://www.wowarmory.com/_images/portraits/wow-80/#{character.wowarmory_gender_id}-#{character.wowarmory_race_id}-#{character.wowarmory_class_id}.gif", :alt => character.name
  end

  def stylized_item_name(item)
    link_to(item.name, item_path(item), :class => "#{item.quality} wow_item with_tooltip")
  end

  def wowhead_item_icon_link_with_stylized_item_name(item)
    item_image_link(item) + " " + stylized_item_name(item)
  end
  
  def item_icon(item)
    styled_wow_icon(item.icon, item.name)
  end
  
  def styled_wow_icon(path, alt = "")
    image_tag(path, :alt => alt, :border => 0, :class => "item_icon")
  end
end
