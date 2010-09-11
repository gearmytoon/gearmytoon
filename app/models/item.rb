class Item < ActiveRecord::Base
  has_friendly_id :wowarmory_item_id, :use_slug => true
  BETA_SLOTS = ['Trinket', 'Relic']
  HORDE = "horde"
  ALLIANCE = "alliance"
  ANY_SIDE = "any_side"
  BOP = 'pickup'
  BOE = 'equipped'
  ORIGINAL_WEAPON_STATS = [:attack_speed, :min_damage, :max_damage, :dps]
  RANGED_WEAPONS = ["Bow", "Gun", "Crossbow", "Thrown"]
  BASE_STATS = [:strength, :agility, :spirit, :intellect, :stamina]
  EQUIPPED_STATS = [:crit, :attack_power, :armor_penetration, :haste, :hit, :spell_power, 
                    :expertise, :mana_regen, :dodge, :defense, :parry, :block]
  WEAPON_STATS = [:melee_attack_speed, :melee_min_damage, :melee_max_damage, :melee_dps,
                  :ranged_attack_speed, :ranged_min_damage, :ranged_max_damage, :ranged_dps]
  TRIUMPH_EMBLEM_ARMORY_ID = 47241
  FROST_EMBLEM_ARMORY_ID = 49426
  WINTERGRASP_MARK_OF_HONOR = 43589
  RESTRICT_TO_NONE = "NONE"
  serialize :bonuses
  serialize :socket_bonuses
  serialize :gem_sockets
  serialize :spell_effects
  named_scope :usable_in_same_slot_as, Proc.new { |item| {:conditions => {:slot => item.slot}} }
  has_many :item_sources, :dependent => :destroy
  has_many :dropped_sources
  has_many :item_popularities, :dependent => :destroy
  has_many :character_items
  #TODO: REMOVE THIS in favor of item sources usable by
  named_scope :usable_by, Proc.new {|wow_class| {:conditions => {:quality => 'epic', :armor_type_id => wow_class.usable_armor_types, :restricted_to => [RESTRICT_TO_NONE, wow_class.name]}}}
  belongs_to :armor_type

  def self.badge_of_frost
    find_by_wowarmory_item_id(FROST_EMBLEM_ARMORY_ID)
  end

  def self.badge_of_triumph
    find_by_wowarmory_item_id(TRIUMPH_EMBLEM_ARMORY_ID)
  end

  def self.wintergrasp_mark
    find_by_wowarmory_item_id(WINTERGRASP_MARK_OF_HONOR)
  end

  def icon(size=:medium)
    dimensions = {:default => "43x43", :medium => "43x43", :large => "64x64", :small => "21x21"}
    extension = size == :large ? 'jpg' : 'png'
    "http://wowarmory.com/wow-icons/_images/#{dimensions[size]}/#{self[:icon]}.#{extension}"
  end

  def armor
    bonuses[:armor]
  end

  def is_a_belt?
    self.slot == "Waist"
  end

  def gem_sockets_with_nil_protection
    sockets = gem_sockets
    sockets.nil? ? [] : sockets
  end

  def base_stats
    self.bonuses.slice(*BASE_STATS)
  end

  def self.beta_slot?(new_item)
    BETA_SLOTS.include?(new_item.slot)
  end

  def bonding_description
    bonding == BOE ? "Binds when equipped" : "Binds when picked up"
  end

  def equipped_stats
    self.bonuses.slice(*EQUIPPED_STATS)
  end

  def restricted_to_a_class?
    restricted_to != RESTRICT_TO_NONE
  end

  def has_armor?
    bonuses.has_key?(:armor)
  end

  def is_a_weapon?
    !weapon_bonuses(:attack_speed).nil?
  end

  def weapon_bonuses(key)
    bonuses["#{weapon_type}_#{key}".to_sym]
  end

  def attack_speed
    weapon_bonuses(:attack_speed)
  end

  def damage_range
    "#{weapon_bonuses(:min_damage)}-#{weapon_bonuses(:max_damage)} Dmg"
  end

  def dps_description
    "(#{weapon_bonuses(:dps)} damage per second)"
  end

  def weapon_type
    RANGED_WEAPONS.include?(armor_type.name) ? "ranged" : "melee"
  end

  def bonuses
    attributes['bonuses'].map_to_hash{|key, value| [translate_key(key), value]}
  end

  def translate_key(key)
    if ORIGINAL_WEAPON_STATS.include?(key)
      "#{weapon_type}_#{key}".to_sym
    else
      key
    end
  end

  def spell_effect_strings
    (self.spell_effects || []).map do |spell_effect|
      spell_effect = spell_effect.with_indifferent_access
      trigger_method = spell_effect[:trigger] == 1 ? "Equip" : "Use"
      "#{trigger_method}: #{spell_effect[:description]}"
    end
  end
  
  def summarize
    self.item_popularities.destroy_all
    all_specs = Spec.all_played_specs
    all_specs.each do |spec|
      used_by_count = self.character_items.used_by(spec).count
      next if used_by_count == 0
      total_used = self.character_items.count
      percentage = (used_by_count.to_f / total_used)*100
      gmt_scores = Character.all(:joins => :character_items, :conditions => ['characters.spec_id = ? AND character_items.item_id = ?', spec.id, self.id], :select => :gmt_score).map(&:gmt_score)
      total_gmt_score = gmt_scores.sum
      average_gmt_score = total_gmt_score / gmt_scores.size
      self.item_popularities.create!(:spec => spec, :percentage => percentage, :average_gmt_score => average_gmt_score)
    end
  end

  def update_popularities!(item_popularities)
    new_popularities = item_popularities.map { |item_popularity_params|
      wow_class = WowClass.find_by_name(item_popularity_params[:wow_class_name])
      spec = wow_class.specs.find_by_name(item_popularity_params[:spec_name])
      self.item_popularities.build({:spec => spec}.merge(item_popularity_params.slice(:average_gmt_score, :percentage)))
    }
    self.item_popularities = new_popularities
    self.save!
  end

end
