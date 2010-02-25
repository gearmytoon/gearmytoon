class MaxDpsImporter
  attr_reader :agent
  
  def initialize
    @agent = WWW::Mechanize.new
    @agent.get("http://www.maxdps.com/hunter/survival.php")
  end

  def import_from_max_dps
    slots = (1..17).to_a - [13] # hunters don't use maxdps's slot 13
    slots.each do |slot| 
      puts "importing slot #{slot} from maxdps"
      import_max_dps_for_item_slot(slot)
    end
  end
  
  def import_max_dps_for_item_slot(slot)
    page = @agent.get("http://www.maxdps.com/hunter/survival_read.php?slotID=#{slot}&tabID=0")
    page.parser.css(".ex .qu5").each do |wowhead_link|
      item_row = wowhead_link.parent.parent
      wowhead_href = wowhead_link['href']
      wowarmory_id = wowhead_href.delete("http://www.wowhead.com/?item=")
      ItemImporter.import_from_wowarmory!(wowarmory_id)
    end
  end
end