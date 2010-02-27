class MaxDpsImporter
  attr_reader :agent
  Hunter = {:base_url => "http://www.maxdps.com/hunter/survival.php", :slot_url_template => "http://www.maxdps.com/hunter/survival_read.php?slotID=", :slots => ((1..17).to_a - [13])}
  Rogue = {:base_url => "http://www.maxdps.com/rogue/combat.php", :slot_url_template => "http://www.maxdps.com/rogue/combat_read.php?slotID=", :slots => ((1..17).to_a - [13, 15])}
  
  def initialize(max_dps_class = MaxDpsImporter::Hunter)
    @max_dps_class = max_dps_class
    @agent = WWW::Mechanize.new
    @agent.get(max_dps_class[:base_url])
  end

  def import_from_max_dps
    slots = @max_dps_class[:slots]
    slots.each do |slot|
      puts "importing slot #{slot} for Hunter from maxdps"
      import_max_dps_for_item_slot(slot)
    end
  end
  
  def import_max_dps_for_item_slot(slot)
    page = @agent.get(@max_dps_class[:slot_url_template] + slot.to_s)
    page.parser.css(".ex .qu5").each do |wowhead_link|
      item_row = wowhead_link.parent.parent
      wowhead_href = wowhead_link['href']
      wowarmory_id = wowhead_href.delete("http://www.wowhead.com/?item=")
      ItemImporter.import_from_wowarmory!(wowarmory_id)
    end
  end
end

