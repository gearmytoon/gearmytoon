class Item < ActiveRecord::Base
  TRIUMPH_EMBLEM_ARMORY_ID = 47241
  FROST_EMBLEM_ARMORY_ID = 49426

  serialize :bonuses
  named_scope :from_emblem_of_triumph, :conditions => {:source_wowarmory_item_id => TRIUMPH_EMBLEM_ARMORY_ID}
  named_scope :from_emblem_of_frost, :conditions => {:source_wowarmory_item_id => FROST_EMBLEM_ARMORY_ID}
  named_scope :from_heroic_dungeon, Proc.new {{:conditions => {:source_area_id => Area.dungeons.map(&:id)}}} #delaying evaluation
  named_scope :usable_in_same_slot_as, Proc.new { |item| {:conditions => {:slot => item.slot}} }

  named_scope :usable_by, Proc.new {|wow_class| {:conditions => {:armor_type_id => wow_class.usable_armor_types}}}
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
end
