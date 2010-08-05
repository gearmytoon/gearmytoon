class WowArmoryImporter

  def initialize
    @agent = Mechanize.new
    @agent.user_agent = 'Mozilla/5.0 Gecko/20070219 Firefox/2.0.0.2' #to ensure we get xml back
  end
  
  def item_tooltip(wowarmory_item_id)
    get_xml(item_tooltip_url(wowarmory_item_id))
  end
  
  def item_info(wowarmory_item_id)
    get_xml(item_info_url(wowarmory_item_id))
  end
  
  def character_sheet(name, realm, locale)
    get_xml(character_sheet_url(name, realm, locale))
  end

  def character_talents(name, realm, locale)
    get_xml(character_talents_url(name, realm, locale))
  end

  def item_info_url(wowarmory_item_id)
    "#{base_url}/item-info.xml?i=#{wowarmory_item_id}"
  end
  
  def item_tooltip_url(wowarmory_item_id)
    "#{base_url}/item-tooltip.xml?i=#{wowarmory_item_id}"
  end

  def character_sheet_url(name, realm, locale)
    "#{base_url(locale)}/character-sheet.xml?r=#{realm}&cn=#{name}"
  end
  
  def character_talents_url(name, realm, locale)
    "#{base_url(locale)}/character-talents.xml?r=#{realm}&cn=#{name}"
  end

  def get_xml(url)
    body = @agent.get(url).body
    # pp body
    Nokogiri::XML(body)
  end

  def base_url(locale = "us")
    domain = locale
    domain = "www" if locale == "us"
    "http://#{domain}.wowarmory.com"
  end
end