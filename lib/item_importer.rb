class ItemImporter < WowArmoryMapper
  QUALITY_ADJECTIVE_LOOKUP = {0 => "poor", 1 => "common", 2 => "uncommon", 3 => "rare", 4 => "epic", 5 => "legendary", 6 => "artifact", 7 => "heirloom"}
  #Unknown 18, 23, 27
  SLOT_CONVERSION = {1 => "Helm", 2 => "Amulet", 3 => "Shoulder", 4 => "Shirt", 5 => "Chest", 6 => "Waist", 7 => "Legs", 8 => "Feet", 
    9 => "Wrist", 10 => "Hands", 11 => "Finger", 12 => "Trinket", 13 => "One-Hand", 14 => "Shield", 15 => "Ranged", 16 => "Back", 
    17 => "Two-Hand", 19 => "Tabard", 20 => "Chest", 21 => "Main Hand", 22 => "Off Hand (Weapon)", 23 => "Off Hand", 24 => "Projectile", 25 => "Ranged", 
    26 => "Ranged", 28 => "Relic"}

  map :name, "//itemTooltip/name"
  map(:slot, "//itemTooltip/equipData/inventoryType") {|data| SLOT_CONVERSION[data]}
  map :icon, "//itemTooltip/icon"
  map :required_level, "//itemTooltip/requiredLevel"
  map :item_level, "//itemTooltip/itemLevel"
  map :required_level_min, "//itemTooltip/requiredLevelMin"
  map :required_level_max, "//itemTooltip/requiredLevelMax"
  map :account_bound, "//itemTooltip/accountBound"
  map :opposing_sides_wowarmory_item_id, "//translationFor/item/@id"
  map(:heroic, "//itemTooltip/heroic") {|data| data == 1}
  map(:side, "//translationFor/@factionEquiv") {|data| {nil => Item::ANY_SIDE, 0 => Item::HORDE, 1 => Item::ALLIANCE}[data]}
  map(:bonding, "//itemTooltip/bonding") {|data| data == 1 ? Item::BOP : Item::BOE}
  map(:armor_type, "//equipData/subclassName") {|data| ArmorType.find_or_create_by_name(data ? data : "Miscellaneous")}
  map(:quality, "//item/@quality") {|data| QUALITY_ADJECTIVE_LOOKUP[data]}
  map_many(:spell_effects, {"//itemTooltip/spellData/spell" => {:description => "//desc", :trigger => "//trigger"}})
  #block?
  map(:bonuses, {"//itemTooltip" => {:strength => "//bonusStrength", :spirit => "//bonusSpirit", :mana_regen => "//bonusManaRegen", 
                                     :spell_power => "//bonusSpellPower", :agility => "//bonusAgility", :dodge => "//bonusDodgeRating", 
                                     :parry => "//bonusParryRating", :defense => "//bonusDefenseSkillRating", :expertise => "//bonusExpertiseRating", 
                                     :stamina => "//bonusStamina", :intellect => "//bonusIntellect", :armor => "//armor",
                                     :attack_power => "//bonusAttackPower", :crit => "//bonusCritRating", :hit => "//bonusHitRating", 
                                     :armor_penetration => "//bonusArmorPenetration", :haste => "//bonusHasteRating", 
                                     :min_damage => "//damageData/damage/min", :max_damage => "//damageData/damage/max", 
                                     :attack_speed => "//damageData/speed", :dps => "//damageData/dps", 
                                     :block_value => "blockValue", :block => "bonusBlockRating", :resilience => "bonusResilienceRating"}
    }) {|bonuses|
      if is_a_gem?
        bonuses.merge(@wowarmory_item_tooltip.at("gemProperties").inner_html.extract_bonuses)
      else
        bonuses
      end
  }
  
  map(:gem_color, "/page/itemInfo/item/@type") {|data| is_a_gem? ? data : nil}
  map_many(:gem_sockets, {"//itemTooltip/socketData/socket" => ['@color']})
  map_many(:restricted_to, "//itemTooltip/allowableClasses/class") {|data| data && data.length == 1 ? data.first : Item::RESTRICT_TO_NONE}

  map(:socket_bonuses, "/page/itemInfo/sockBonuses") {|data|
    begin
      #get socket bonuses from thottbot
      ItemSocketImporter.new(wowarmory_item_id).get_socket_bonuses.extract_bonuses
    rescue Exception => ex
      Rails.logger.error(ex)
    end
  }

  attr_reader :wowarmory_item_id
  def initialize(wowarmory_item_id, wowarmory_item_info, wowarmory_item_tooltip)
    @wowarmory_item_info = wowarmory_item_info
    @wowarmory_item_tooltip = wowarmory_item_tooltip
    @wowarmory_item_id = wowarmory_item_id
  end
  
  def is_a_gem?
    !@wowarmory_item_tooltip.at("gemProperties").nil?
  end
  
  def type_to_be_imported
    if is_a_gem?
      GemItem
    else
      Item
    end
  end

  def import!
    returning type_to_be_imported.find_or_create_by_wowarmory_item_id(wowarmory_item_id) do |item|
      item.update_attributes!(mapped_options.merge({:wowarmory_item_id => wowarmory_item_id,
                                :item_sources => get_item_sources(item)}))
    end
  end
  

  
    
  def get_dropped_sources(item)
    @wowarmory_item_info.xpath("//dropCreatures/creature").map do |creature|
      DroppedSource.create(:item => item, :creature => find_or_create_creature(creature), :drop_rate => creature['dropRate'])
    end
  end


  # <quest area=\"Icecrown\" id=\"24796\" level=\"80\" name=\"A Victory For The Silver Covenant\" reqMinLevel=\"80\" suggestedPartySize=\"0\"/>
  def find_or_create_quest(quest_xml)
    returning Quest.find_or_create_by_wowarmory_quest_id(quest_xml['id']) do |quest|
      quest.update_attributes!(:name => quest_xml['name'], 
                                :level => quest_xml['level'],
                                :required_min_level => quest_xml['reqMinLevel'],
                                :suggested_party_size => quest_xml['suggestedPartySize'],
                                :area => find_or_create_area(quest_xml))
    end
  end


  def find_or_create_creature(creature_xml)
    area = find_or_create_area(creature_xml)
    returning Creature.find_or_create_by_wowarmory_creature_id(creature_xml['id']) do |creature|
      creature.update_attributes!(:name => creature_xml['name'], :creature_type => creature_xml['type'],
                                :classification => creature_xml['classification'], :min_level => creature_xml['minLevel'],
                                :max_level => creature_xml['maxLevel'], :area => area)
    end
  end
  
  def find_or_create_area(area_xml)
    area_name = area_xml['area']
    area_difficulty = area_xml['heroic'] == "1" ? Area::HEROIC : Area::NORMAL
    area = Area.find_or_create_by_difficulty_and_name(area_difficulty, area_name)
    if !(area_id = @wowarmory_item_tooltip.at("itemTooltip/itemSource")['areaId']).blank?
      area.update_attribute(:wowarmory_area_id, area_id)
    end
    area
  end
  
  def get_created_sources(item)
    @wowarmory_item_info.xpath("//createdBy/spell").map do |spell|
      trade_skill = TradeSkill.find_or_create_by_wowarmory_name(spell['icon'])
      created_source = CreatedSource.create(:trade_skill => trade_skill, :item => item)
      items_made_from = spell.xpath("//reagent").map do |reagent|
        ItemUsedToCreate.create!(:wowarmory_item_id => reagent['id'], :quantity => reagent['count'], :item_source => created_source)
      end
      created_source
    end
  end
  
  def get_quest_sources(item)
    @wowarmory_item_info.xpath("//rewardFromQuests/quest").map do |quest|
      QuestSource.create(:item => item, :quest => find_or_create_quest(quest))
    end
  end
  
  def get_container_sources(item)
    @wowarmory_item_info.xpath("//containerObjects/object").map do |container|
      ContainerSource.create(:item => item, :container => find_or_create_container(container), :drop_rate => container['dropRate'])
    end
  end
  
  def find_or_create_container(container_xml)
    returning Container.find_or_create_by_wowarmory_container_id(container_xml['id']) do |container|
      container.update_attributes!(:name => container_xml['name'], 
                                :wowarmory_container_id => container_xml['id'],
                                :area => find_or_create_area(container_xml))
    end
  end
  
  def get_purchased_sources(item)
    @wowarmory_item_info.xpath("//itemInfo/item/vendors/creature").map do |vendor|
      cost = @wowarmory_item_info.at("//itemInfo/item/cost")
      next nil if cost.nil?
      if cost.search("token").any?
        purchase_source = PurchaseSource.create!(:item => item, :vendor => find_or_create_creature(vendor))
        cost.search("token").map do |token|
          purchase_source.items_used_to_purchase.create!(:quantity => token['count'], :wowarmory_item_id => token['id'])
        end
        purchase_source
      else
        if cost['arena']
          ArenaSource.create(:arena_point_cost => cost['arena'],:honor_point_cost => cost['honor'], :item => item, :vendor => find_or_create_creature(vendor))
        elsif cost['honor']
          HonorSource.create(:honor_point_cost => cost['honor'], :item => item, :vendor => find_or_create_creature(vendor))
        end
      end
    end.compact
  end
  
  def get_item_sources(item)
    get_dropped_sources(item)
    returning([]) do |sources|
      sources = sources.concat(get_dropped_sources(item))
      sources = sources.concat(get_created_sources(item))
      sources = sources.concat(get_quest_sources(item))
      sources = sources.concat(get_container_sources(item))
      sources = sources.concat(get_purchased_sources(item))
    end
  end

  def self.import_from_wowarmory!(wowarmory_item_id)
    begin
      armory_importer = WowArmoryImporter.new(RAILS_ENV != "production") #our linux install cannot support all the subdirs used by caching
      ItemImporter.new(wowarmory_item_id, armory_importer.item_info(wowarmory_item_id), armory_importer.item_tooltip(wowarmory_item_id)).import!
    rescue WowArmoryDataNotFound => e
      STDERR.puts e
    end
  end

end
