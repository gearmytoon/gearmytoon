class ItemImporter
  QUALITY_ADJECTIVE_LOOKUP = {0 => "poor", 1 => "common", 2 => "uncommon", 3 => "rare", 4 => "epic", 5 => "legendary", 6 => "artifact", 7 => "heirloom"}
  RANGED_WEAPONS = ["Bow", "Gun", "Crossbow", "Thrown"]
  #Unknown 18, 23, 27
  SLOT_CONVERSION = {1 => "Helm", 2 => "Amulet", 3 => "Shoulder", 4 => "Shirt", 5 => "Chest", 6 => "Waist", 7 => "Legs", 8 => "Feet", 
    9 => "Wrist", 10 => "Hands", 11 => "Finger", 12 => "Trinket", 13 => "One-Hand", 14 => "Shield", 15 => "Ranged", 16 => "Back", 
    17 => "Two-Hand", 19 => "Tabard", 20 => "Chest", 21 => "Main Hand", 22 => "Off Hand (Weapon)", 23 => "Off Hand", 24 => "Projectile", 25 => "Ranged", 
    26 => "Ranged", 28 => "Relic"}

  class << self
    def map(name, xpath, &block)
      @mappings ||= {}.with_indifferent_access
      @mappings[name] = {:xpath => xpath, :translate_with => block}
    end
    def add_mapping(name, value)
      @mappings ||= {}.with_indifferent_access
      @mappings[name] = value
    end
    def mappings
      @mappings
    end
  end
  
  def mapped_options
    returning({}) do |result|
      self.class.mappings.each do |name, args|
        data = @wowarmory_item_tooltip.at(args[:xpath]) ? @wowarmory_item_tooltip.at(args[:xpath]).inner_html : nil
        data = @wowarmory_item_info.at(args[:xpath]) ? @wowarmory_item_info.at(args[:xpath]).inner_html : nil if data.nil?
        data = args[:translate_with].call(data) if args[:translate_with]
        result[name] = data
      end
    end
  end

  def get_item_bonuses
    returning(build_standard_bonuses) do |bonuses|
      if is_a_gem?
        bonuses.merge!(@wowarmory_item_tooltip.at("gemProperties").inner_html.extract_bonuses)
      elsif !@wowarmory_item_tooltip.at("damageData").inner_html.blank?
        damage_data = @wowarmory_item_tooltip.at("damageData")
        if RANGED_WEAPONS.include?(@wowarmory_item_tooltip.at("//equipData/subclassName").inner_html)
          weapon_type = "ranged"
        else
          weapon_type = "melee"
        end
        bonuses["#{weapon_type}_min_damage".to_sym] = (damage_data/:damage/:min).inner_html.to_i
        bonuses["#{weapon_type}_max_damage".to_sym] = (damage_data/:damage/:max).inner_html.to_i
        bonuses["#{weapon_type}_attack_speed".to_sym] = (damage_data/:speed).inner_html.to_f
        bonuses["#{weapon_type}_dps".to_sym] = (damage_data/:dps).inner_html.to_f
      end
    end
  end

  def build_standard_bonuses
    stat_mappings = {:agility => "bonusAgility", :stamina => "bonusStamina", :intellect => "bonusIntellect", :armor => "armor",
     :attack_power => "bonusAttackPower", :crit => "bonusCritRating", :hit => "bonusHitRating", :armor_penetration => "bonusArmorPenetration",
     :haste => "bonusHasteRating"}
    returning({}) do |bonuses|
      stat_mappings.each do |our_stat_name, armory_element_name|
        armory_element = @wowarmory_item_tooltip.at(armory_element_name)
        bonuses[our_stat_name] = armory_element.inner_html.to_i if armory_element
      end
    end
  end

  # map_to_a_hash(:bonuses, {:agility => "bonusAgility", :stamina => "bonusStamina", :intellect => "bonusIntellect", :armor => "armor",
  #  :attack_power => "bonusAttackPower", :crit => "bonusCritRating", :hit => "bonusHitRating", :armor_penetration => "bonusArmorPenetration",
  #  :haste => "bonusHasteRating"})
  map :name, "//itemTooltip/name"
  map(:slot, "//itemTooltip/equipData/inventoryType") {|data| SLOT_CONVERSION[data.to_i]}
  map :icon, "//itemTooltip/icon"
  map :required_level, "//itemTooltip/requiredLevel"
  map :item_level, "//itemTooltip/itemLevel"
  map :required_level_min, "//itemTooltip/requiredLevelMin"
  map :required_level_max, "//itemTooltip/requiredLevelMax"
  map :account_bound, "//itemTooltip/accountBound"
  map :opposing_sides_wowarmory_item_id, "//translationFor/item/@id"
  map(:heroic, "//itemTooltip/heroic") {|data| data == "1"}
  map(:side, "//translationFor/@factionEquiv") {|data| {nil => Item::ANY_SIDE, "0" => Item::HORDE, "1" => Item::ALLIANCE}[data]}
  map(:bonding, "//itemTooltip/bonding") {|data| data == "1" ? Item::BOP : Item::BOE}
  map(:armor_type, "//equipData/subclassName") {|data| ArmorType.find_or_create_by_name(data ? data : "Miscellaneous")}
  map(:quality, "//item/@quality") {|data| QUALITY_ADJECTIVE_LOOKUP[data.to_i]}
  
  def get_spell_effects
    (@wowarmory_item_tooltip/:itemTooltip/:spellData/:spell).map do |spell|
      {:description => (spell/:desc).inner_html, :trigger => (spell/:trigger).inner_html.to_i}
    end
  end
  
  attr_reader :wowarmory_item_id
  def initialize(wowarmory_item_id)
    armory_importer = WowArmoryImporter.new
    @wowarmory_item_info = armory_importer.item_info(wowarmory_item_id)
    @wowarmory_item_tooltip = armory_importer.item_tooltip(wowarmory_item_id)
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
                                :bonuses => get_item_bonuses, 
                                :restricted_to => get_restricted_to, :item_sources => get_item_sources(item), 
                                :gem_color => get_gem_color, :gem_sockets => get_gem_sockets, :socket_bonuses => get_socket_bonuses,
                                :spell_effects => get_spell_effects}))
    end
  end
  

  
  def get_socket_bonuses
    begin
      #get socket bonuses from thottbot
      ItemSocketImporter.new(wowarmory_item_id).get_socket_bonuses.extract_bonuses
    rescue Exception => ex
      Rails.logger.error(ex)
    end
  end
  
  def get_gem_color
    if is_a_gem?
      @wowarmory_item_info.at("item")['type']
    end
  end
  
  def get_gem_sockets
    (@wowarmory_item_tooltip/:itemTooltip/:socketData/:socket).map do |socket|
      socket['color']
    end
  end
  
  def get_dropped_sources(item)
    @wowarmory_item_info.xpath("//dropCreatures/creature").map do |creature|
      area_name = creature['area'] #TODO DELETE THIS use through association
      area_difficulty = creature['heroic'] == "1" ? Area::HEROIC : Area::NORMAL
      area = Area.find_or_create_by_difficulty_and_name(area_difficulty, area_name)
      DroppedSource.create(:source_area => area, :item => item, :creature => find_or_create_creature(creature))
    end
  end

  def find_or_create_creature(creature_xml)
    area_name = creature_xml['area']
    area_difficulty = creature_xml['heroic'] == "1" ? Area::HEROIC : Area::NORMAL
    area = Area.find_or_create_by_difficulty_and_name(area_difficulty, area_name)
    if !(area_id = @wowarmory_item_tooltip.at("itemTooltip/itemSource")['areaId']).blank?
      area.update_attribute(:wowarmory_area_id, area_id)
    end
    returning Creature.find_or_create_by_wowarmory_creature_id(creature_xml['id']) do |creature|
      creature.update_attributes!(:name => creature_xml['name'], :creature_type => creature_xml['type'],
                                :classification => creature_xml['classification'], :min_level => creature_xml['minLevel'],
                                :max_level => creature_xml['maxLevel'], :area => area)
    end
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
      area_name = quest['area']
      area_difficulty = quest['heroic'] == "1" ? Area::HEROIC : Area::NORMAL
      area = Area.find_or_create_by_difficulty_and_name(area_difficulty, area_name)
      created_source = QuestSource.create(:item => item, :source_area => area, :level => quest['level'], 
            :name => quest['name'], :required_min_level => quest['reqMinLevel'], :suggested_party_size => quest['suggestedPartySize'],
            :wowarmory_quest_id => quest['id'])
      created_source
    end
  end
  
  def get_container_sources(item)
    @wowarmory_item_info.xpath("//containerObjects/object").map do |container|
      area_name = container['area']
      area_difficulty = container['heroic'] == "1" ? Area::HEROIC : Area::NORMAL
      area = Area.find_or_create_by_difficulty_and_name(area_difficulty, area_name)
      ContainerSource.create(:item => item, :source_area => area, 
            :name => container['name'], :drop_rate => container['dropRate'], :wowarmory_container_id => container['id'])
    end
  end
  
  def get_purchased_sources(item)
    @wowarmory_item_info.xpath("//itemInfo/item/vendors/creature").map do |vendor|
      cost = @wowarmory_item_info.at("//itemInfo/item/cost")
      next nil if cost.nil?
      if cost.search("token").size == 1
        token_cost = cost.search("token").first
        EmblemSource.create!(:wowarmory_token_item_id => token_cost['id'], :token_cost => token_cost['count'], :item => item)
      elsif cost.search("token").size > 1
        purchase_source = PurchaseSource.create!(:item => item, :vendor => find_or_create_creature(vendor))
        cost.search("token").map do |token|
          purchase_source.items_made_from.create!(:quantity => token['count'], :wowarmory_item_id => token['id'])
        end
        purchase_source
      else
        if cost && cost['arena']
          ArenaSource.create(:arena_point_cost => cost['arena'],:honor_point_cost => cost['honor'], :item => item)
        elsif cost && cost['honor']
          HonorSource.create(:honor_point_cost => cost['honor'], :item => item)
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

  def get_restricted_to
    allowable_classes = (@wowarmory_item_tooltip/:itemTooltip/:allowableClasses/:class).map(&:inner_html)
    #TODO FIX ME, MIGRATE ITEMS
    allowable_classes && allowable_classes.length == 1 ? allowable_classes.first : Item::RESTRICT_TO_NONE
  end

  def self.import_from_wowarmory!(wowarmory_item_id)
    begin
      ItemImporter.new(wowarmory_item_id).import!
    rescue WowArmoryDataNotFound => e
      STDERR.puts e
    end
  end

  def self.import_all_items_that_contain!(term)
    items = api.search_items(term)
    items.map do |item|
      import_from_wowarmory!(item.id)
    end
  end

end
