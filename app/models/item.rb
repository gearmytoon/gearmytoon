class Item < ActiveRecord::Base
  BETA_SLOTS = ['Trinket', 'Relic']
  HORDE = "horde"
  ALLIANCE = "alliance"
  ANY_SIDE = "any_side"
  BOP = 'pickup'
  BOE = 'equipped'
  BASE_STATS = [:strength, :agility, :spirit, :intellect, :stamina]
  TRIUMPH_EMBLEM_ARMORY_ID = 47241
  FROST_EMBLEM_ARMORY_ID = 49426
  WINTERGRASP_MARK_OF_HONOR = 43589
  RESTRICT_TO_NONE = "NONE"
  serialize :bonuses
  serialize :socket_bonuses
  serialize :gem_sockets
  named_scope :usable_in_same_slot_as, Proc.new { |item| {:conditions => {:slot => item.slot}} }
  has_many :item_sources, :dependent => :destroy
  has_many :dropped_sources
  has_many :emblem_sources
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

  def token_cost
    emblem_sources.first.token_cost
  end

  def source_area
    dropped_sources.first.source_area
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
    self.bonuses.except(*BASE_STATS)
  end
  
  def restricted_to_a_class?
    restricted_to != RESTRICT_TO_NONE
  end
  
  def has_armor?
    bonuses.has_key?(:armor)
  end
end
