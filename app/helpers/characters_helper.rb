module CharactersHelper
  
  def wowhead_item_path(item)
    "http://www.wowhead.com/?item=#{item.item_id}"
  end
  
  def wowhead_item_image_link(item)
    link_to image_tag(item.icon, :alt => item.name, :border => 0, :class => "item_icon"), wowhead_item_path(item)
  end

  def character_icon(character)
    image_tag "http://www.wowarmory.com/_images/portraits/wow-80/#{character.wowarmory_gender_id}-#{character.wowarmory_race_id}-#{character.wowarmory_class_id}.gif", :alt => character.name
  end

  def stylized_item_name(item)
    link_to(item.name, wowhead_item_path(item), :class =>  "#{item.quality} wow_item")
  end

  def wowhead_npc_link(npc)
    #TODO: npc.id is broken, need to parse from the @url attr, fix ItemDropCreature class
    link_to npc.name, "http://www.wowhead.com/?npc=#{npc.id}"
  end

  def wowhead_item_icon_link_with_stylized_item_name(item)
    wowhead_item_image_link(item) + " " + stylized_item_name(item)
  end
end
