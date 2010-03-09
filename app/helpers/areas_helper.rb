module AreasHelper
  def wowhead_area_link(area)
    link_to "#{area.name}", "http://www.wowhead.com/?zone=#{area.wowarmory_id}"
  end
end
