class Item < ActiveRecord::Base
  TRIUMPH_EMBLEM_ARMORY_ID = 47241
  FROST_EMBLEM_ARMORY_ID = 49426
  RESTRICT_TO_NONE = "NONE"
  
  serialize :bonuses
  named_scope :usable_in_same_slot_as, Proc.new { |item| {:conditions => {:slot => item.slot}} }
  named_scope :from_item_source, Proc.new {|item_sources| {:joins => :item_sources, :conditions => ["items.id = item_sources.item_id AND item_sources.id IN (?)",item_sources]}}
  has_many :item_sources
  has_many :dropped_sources
  has_many :emblem_sources
  #
  named_scope :usable_by, Proc.new {|wow_class| {:conditions => {:armor_type_id => wow_class.usable_armor_types, :restricted_to => [RESTRICT_TO_NONE, wow_class.name]}}}
  belongs_to :armor_type
  belongs_to :source_area, :class_name => "Area"

  def self.badge_of_frost
    fetch_from_api(FROST_EMBLEM_ARMORY_ID)
  end

  def self.badge_of_triumph
    fetch_from_api(TRIUMPH_EMBLEM_ARMORY_ID)
  end

  def self.fetch_from_api(item_id)
    api = Wowr::API.new
    item = api.get_item(item_id)
  end

  def item_id #to quack the same as wowr wowitems
    wowarmory_item_id
  end

  def change_in_stats_from(other_item)
    self.bonuses.subtract_values(other_item.bonuses)
  end
  
  def dropped_item?
    dropped_sources.any?
  end
  
  def purchased_item?
    emblem_sources.any?
  end
  
  def token_cost
    emblem_sources.first.token_cost
  end
  
  def source_area
    dropped_sources.first.source_area
  end
end
