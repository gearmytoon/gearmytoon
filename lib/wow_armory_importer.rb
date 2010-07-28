class WowArmoryImporter

  def self.import_from_wowarmory!(wowarmory_item_id)
    info = get_xml(item_info_url(wowarmory_item_id))
    tooltip = get_xml(item_tooltip_url(wowarmory_item_id))
    pp info
    pp tooltip
  end

  def self.get_xml(url)
    response = http_request(url)
    Hpricot.XML(response)
  end

  def self.http_request(url)
    req = Net::HTTP::Get.new(url)
    req["user-agent"] = 'Mozilla/5.0 Gecko/20070219 Firefox/2.0.0.2' #ensure xml is returned
    uri = URI.parse(URI.escape(url))
    http = Net::HTTP.new(uri.host, uri.port)
    res = http.request req
    res.body
  end
  def self.item_info_url(wowarmory_item_id)
    "http://www.wowarmory.com/item-info.xml?i=#{wowarmory_item_id}"
  end
  
  def self.item_tooltip_url(wowarmory_item_id)
    "http://www.wowarmory.com/item-tooltip.xml?i=#{wowarmory_item_id}"
  end
end