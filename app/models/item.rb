class Item < ActiveRecord::Base
  BOP = 'pickup'
  BOE = 'equipped'
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
  named_scope :usable_by, Proc.new {|wow_class| {:conditions => {:armor_type_id => wow_class.usable_armor_types, :restricted_to => [RESTRICT_TO_NONE, wow_class.name]}}}
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

  def item_id #to quack the same as wowr wowitems
    wowarmory_item_id
  end

  def token_cost
    emblem_sources.first.token_cost
  end

  def source_area
    dropped_sources.first.source_area
  end
end
