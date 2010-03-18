module AreasHelper
  def wowhead_area_link(area)
    link_to "#{area.full_name}", "http://www.wowhead.com/?zone=#{area.wowarmory_area_id}"
  end
end
