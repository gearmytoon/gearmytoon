class WowArmoryImporter

  def initialize(wowarmory_item_id)
    @wowarmory_item_id = wowarmory_item_id
    @agent = Mechanize.new
    @agent.user_agent = 'Mozilla/5.0 Gecko/20070219 Firefox/2.0.0.2' #to ensure we get xml back
  end
  
  def tooltip
    get_xml(item_tooltip_url(@wowarmory_item_id))
  end
  
  def info
    get_xml(item_info_url(@wowarmory_item_id))
  end

  private

  def get_xml(url)
    body = @agent.get(url).body
    # pp body
    Nokogiri::XML(body)
  end

  def item_info_url(wowarmory_item_id)
    "http://www.wowarmory.com/item-info.xml?i=#{wowarmory_item_id}"
  end
  
  def item_tooltip_url(wowarmory_item_id)
    "http://www.wowarmory.com/item-tooltip.xml?i=#{wowarmory_item_id}"
  end
end