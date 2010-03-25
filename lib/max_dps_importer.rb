class MaxDpsImporter
  attr_reader :agent
  Hunter = {:base_url => "http://www.maxdps.com/hunter/survival.php", :slot_url_template => "http://www.maxdps.com/hunter/survival_read.php?slotID=", :slots => ((1..17).to_a - [13])}
  Mage = {:base_url => "http://www.maxdps.com/mage/fire.php", :slot_url_template => "http://www.maxdps.com/mage/fire_read.php?slotID=", :slots => (1..14).to_a}
  Rogue = {:base_url => "http://www.maxdps.com/rogue/combat.php", :slot_url_template => "http://www.maxdps.com/rogue/combat_read.php?slotID=", :slots => ((1..17).to_a - [13, 15])}
  FuryWarrior = {:base_url => "http://www.maxdps.com/warrior/fury.php", :slot_url_template => "http://www.maxdps.com/warrior/fury_read.php?slotID=", :slots => (1..14).to_a}
  ProtectionWarrior = {:base_url => "http://www.maxdps.com/warrior/protection.php", :slot_url_template => "http://www.maxdps.com/warrior/protection_read.php?slotID=", :slots => (1..14).to_a}
  AfflictionWarlock = {:base_url => "http://www.maxdps.com/warlock/affliction.php", :slot_url_template => "http://www.maxdps.com/warlock/affliction_read.php?slotID=", :slots => (1..14).to_a}
  RetPaladin = {:base_url => "http://www.maxdps.com/paladin/retribution.php", :slot_url_template => "http://www.maxdps.com/paladin/retribution_read.php?slotID=", :slots => (1..14).to_a}
  HolyPaladin = {:base_url => "http://www.maxdps.com/paladin/holy.php", :slot_url_template => "http://www.maxdps.com/paladin/holy_read.php?slotID=", :slots => (1..14).to_a}
  ShadowPreist = {:base_url => "http://www.maxdps.com/priest/shadow.php", :slot_url_template => "http://www.maxdps.com/priest/shadow_read.php?slotID=", :slots => (1..14).to_a}
  HolyPreist = {:base_url => "http://www.maxdps.com/priest/holy.php", :slot_url_template => "http://www.maxdps.com/priest/holy_read.php?slotID=", :slots => (1..14).to_a}
  EnhancementShaman = {:base_url => "http://www.maxdps.com/shaman/enhancement.php", :slot_url_template => "http://www.maxdps.com/shaman/enhance_read.php?slotID=", :slots => (1..14).to_a}
  ElementalShaman = {:base_url => "http://www.maxdps.com/shaman/elemental.php", :slot_url_template => "http://www.maxdps.com/shaman/ele_read.php?slotID=", :slots => (1..14).to_a}
  RestorationShaman = {:base_url => "http://www.maxdps.com/shaman/restoration.php", :slot_url_template => "http://www.maxdps.com/shaman/resto_read.php?slotID=", :slots => (1..14).to_a}
  Boomkin = {:base_url => "http://www.maxdps.com/druid/moonkin.php", :slot_url_template => "http://www.maxdps.com/druid/moonkin_read.php?slotID=", :slots => (1..14).to_a}
  RestorationDruid = {:base_url => "http://www.maxdps.com/druid/restoration.php", :slot_url_template => "http://www.maxdps.com/druid/resto_read.php?slotID=", :slots => (1..14).to_a}
  FeralDruid = {:base_url => "http://www.maxdps.com/druid/feral.php", :slot_url_template => "http://www.maxdps.com/druid/feral_read.php?slotID=", :slots => (1..14).to_a}
  UnholyDeathKnight = {:base_url => "http://www.maxdps.com/deathknight/unholy.php", :slot_url_template => "http://www.maxdps.com/deathknight/unholy_read.php?slotID=", :slots => (1..14).to_a}

  def self.build_all_lists
    MaxDpsImporter.constants.each do |klass_spec_to_import|
      max_dps_importer = MaxDpsImporter.new(klass_spec_to_import)
      max_dps_importer.import_from_max_dps
    end
  end

  def initialize(klass)
    @max_dps_class_name = klass.to_s.camelize
    @max_dps_class = "#{self.class}::#{@max_dps_class_name}".constantize
    @agent = WWW::Mechanize.new
    @agent.get(@max_dps_class[:base_url])
  end

  def import_from_max_dps
    file_name = File.join("#{RAILS_ROOT}/db/data/items", "#{@max_dps_class_name.underscore}.txt")
    File.delete(file_name) if File.exists?(file_name)
    File.open(file_name,"w+") do |file|
      slots = @max_dps_class[:slots]
      slots.each do |slot|
        puts "building item list for slot #{slot} for #{@max_dps_class_name} from maxdps"
        import_max_dps_for_item_slot(file, slot)
      end
    end
  end

  def import_max_dps_for_item_slot(file, slot)
    page = @agent.get(@max_dps_class[:slot_url_template] + slot.to_s)
    page.parser.css(".ex .qu5").each do |wowhead_link|
      item_row = wowhead_link.parent.parent
      wowhead_href = wowhead_link['href']
      wowarmory_id = wowhead_href.delete("http://www.wowhead.com/?item=")
      file.write(wowarmory_id + "\n")
    end
  end
end

