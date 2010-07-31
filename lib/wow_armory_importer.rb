class WowArmoryImporter

  def initialize(wowarmory_item_id)
    @wowarmory_item_id = wowarmory_item_id
  end
  
  def tooltip
    get_xml(item_tooltip_url(@wowarmory_item_id))
  end
  
  def info
    get_xml(item_info_url(@wowarmory_item_id))
  end

  def get_xml(url)
    response = http_request(url)
    Hpricot.XML(response)
  end

  def http_request(url)
    req = Net::HTTP::Get.new(url)
    req["user-agent"] = 'Mozilla/5.0 Gecko/20070219 Firefox/2.0.0.2' #ensure xml is returned
    uri = URI.parse(URI.escape(url))
    http = Net::HTTP.new(uri.host, uri.port)
    res = http.request req
    res.body
  end

  def item_info_url(wowarmory_item_id)
    "http://www.wowarmory.com/item-info.xml?i=#{wowarmory_item_id}"
  end
  
  def item_tooltip_url(wowarmory_item_id)
    "http://www.wowarmory.com/item-tooltip.xml?i=#{wowarmory_item_id}"
  end
end