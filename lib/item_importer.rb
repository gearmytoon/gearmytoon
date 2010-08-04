class ItemImporter
  QUALITY_ADJECTIVE_LOOKUP = {0 => "poor", 1 => "common", 2 => "uncommon", 3 => "rare", 4 => "epic", 5 => "legendary", 6 => "artifact", 7 => "heirloom"}
  RANGED_WEAPONS = ["Bow", "Gun", "Crossbow", "Thrown"]
  #Unknown 18, 23, 27
  SLOT_CONVERSION = {1 => "Helm", 2 => "Amulet", 3 => "Shoulder", 4 => "Shirt", 5 => "Chest", 6 => "Waist", 7 => "Legs", 8 => "Feet", 
    9 => "Wrist", 10 => "Hands", 11 => "Finger", 12 => "Trinket", 13 => "One-Hand", 14 => "Shield", 15 => "Ranged", 16 => "Back", 
    17 => "Two-Hand", 19 => "Tabard", 20 => "Chest", 21 => "Main Hand", 22 => "Off Hand (Weapon)", 23 => "Off Hand", 24 => "Projectile", 25 => "Ranged", 
    26 => "Ranged", 28 => "Relic"}

  attr_reader :wowarmory_item_id
  def initialize(wowarmory_item_id)
    armory_importer = WowArmoryImporter.new(wowarmory_item_id)
    @wowarmory_item_info = armory_importer.info
    @wowarmory_item_tooltip = armory_importer.tooltip
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
  
  def get_name
    @wowarmory_item_tooltip.at("//itemTooltip/name").inner_html
  end

  def get_icon
    @wowarmory_item_tooltip.at("//itemTooltip/icon").inner_html
  end

  def find_or_import!
    item = type_to_be_imported.find_by_wowarmory_item_id(wowarmory_item_id)
    item.nil? ? import! : item
  end

  def import!
    returning type_to_be_imported.find_or_create_by_wowarmory_item_id(wowarmory_item_id) do |item|
      item.update_attributes!(:wowarmory_item_id => wowarmory_item_id, :name => get_name,
                                :quality => quality, :icon => get_icon, :bonuses => get_item_bonuses, 
                                :armor_type => ArmorType.find_or_create_by_name(armor_type_name), :slot => slot, 
                                :restricted_to => get_restricted_to, :item_sources => get_item_sources(item), 
                                :gem_color => get_gem_color, :gem_sockets => get_gem_sockets, :socket_bonuses => get_socket_bonuses,
                                :bonding => get_item_bonding, :side => get_item_side, :opposing_sides_wowarmory_item_id => get_opposing_sides_wowarmory_item_id, :item_level => get_item_level, 
                                :required_level => get_required_level, :spell_effects => get_spell_effects, :heroic => get_heroic)
    end
  end
  
  def get_opposing_sides_wowarmory_item_id
    if translation = @wowarmory_item_info.at("//translationFor")
      translation.at("item")['id']
    end
  end
  
  def get_item_side
    if !(translation = @wowarmory_item_info.at("//translationFor")).nil?
      translation['factionEquiv'] == "0" ? Item::HORDE : Item::ALLIANCE
    else
      Item::ANY_SIDE
    end
  end
  
  def get_heroic
    element = @wowarmory_item_tooltip.at("//itemTooltip/heroic")
    !element.nil? && element.inner_html == "1"
  end
  def get_spell_effects
    (@wowarmory_item_tooltip/:itemTooltip/:spellData/:spell).map do |spell|
      {:description => (spell/:desc).inner_html, :trigger => (spell/:trigger).inner_html.to_i}
    end
  end
  
  def get_required_level
    @wowarmory_item_tooltip.at("//itemTooltip/requiredLevel").inner_html
  end
  
  def get_item_level
    @wowarmory_item_tooltip.at("//itemTooltip/itemLevel").inner_html
  end
  
  def get_item_bonding
    bonding = @wowarmory_item_tooltip.at("//itemTooltip/bonding").inner_html
    bonding == "1" ? Item::BOP : Item::BOE
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
      area_name = creature['area']
      area_difficulty = creature['heroic'] == "1" ? Area::HEROIC : Area::NORMAL
      area = Area.find_or_create_by_difficulty_and_name(area_difficulty, area_name)
      if !(area_id = @wowarmory_item_tooltip.at("itemTooltip/itemSource")['areaId']).blank?
        area.update_attribute(:wowarmory_area_id, area_id)
      end
      creature = Creature.find_or_create_by_name_and_area_id(creature['name'], area.id)
      DroppedSource.create(:source_area => area, :item => item, :creature => creature)
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
  
  def get_item_sources(item)
    get_dropped_sources(item)
    returning([]) do |sources|
      sources = sources.concat(get_dropped_sources(item))
      sources = sources.concat(get_created_sources(item))
      cost = @wowarmory_item_info.at("//item/cost")
      if cost && (token_cost = cost.at("//token"))
        #TODO RE-ADD functionality
        if cost.search("token").size == 1
          sources << EmblemSource.create(:wowarmory_token_item_id => token_cost['id'], :token_cost => token_cost['count'], :item => item)
        end
        # if wowarmory_item.cost.tokens.length == 1 #TODO: determine the cost of items that cost more then one kind of thing
      # end
      end
      if cost && cost['arena']
        sources << ArenaSource.create(:arena_point_cost => cost['arena'],:honor_point_cost => cost['honor'], :item => item)
      elsif cost && cost['honor']
        sources << HonorSource.create(:honor_point_cost => cost['honor'], :item => item)
      end
    end
  end
  
  def get_restricted_to
    allowable_classes = (@wowarmory_item_tooltip/:itemTooltip/:allowableClasses/:class).map(&:inner_html)
    #TODO FIX ME, MIGRATE ITEMS
    allowable_classes && allowable_classes.length == 1 ? allowable_classes.first : Item::RESTRICT_TO_NONE
  end
  
  def armor_type_name
    subclass_name = @wowarmory_item_tooltip.at("//equipData/subclassName")
    subclass_name ? subclass_name.inner_html : "Miscellaneous"
  end

  def slot
    SLOT_CONVERSION[(@wowarmory_item_tooltip/:itemTooltip/:equipData/:inventoryType).inner_html.to_i]
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
  
  def quality
    QUALITY_ADJECTIVE_LOOKUP[@wowarmory_item_info.at("item")['quality'].to_i]
  end

  def self.import_from_wowarmory!(wowarmory_item_id)
    begin
      ItemImporter.new(wowarmory_item_id).import!
    rescue Wowr::Exceptions::ItemNotFound => e
      STDERR.puts e
    end
  end

  def self.find_or_import!(wowarmory_item_id)
    begin
      ItemImporter.new(wowarmory_item_id).find_or_import!
    rescue Wowr::Exceptions::ItemNotFound => e
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
