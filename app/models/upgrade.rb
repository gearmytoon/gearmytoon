class Upgrade < ActiveRecord::Base
  serialize :bonus_changes
  belongs_to :character
  belongs_to :old_item, :class_name => "Item"
  belongs_to :new_item_source, :class_name => "ItemSource"
  before_create :calculate_dps_change
  named_scope :with_sources, Proc.new {|item_sources, for_pvp| 
    {:conditions => {:new_item_source_id => item_sources, :for_pvp => for_pvp}, :order => "dps_change DESC"}
  }
  def stat_change_between(new_item, old_item)
    apply_hard_caps(new_item.change_in_stats_from(old_item))
  end

  def apply_hard_caps(change_in_bonuses)
    bonuses_after_hard_cap = {}
    hard_caps = character.hard_caps
    total_item_bonuses = character.total_item_bonuses
    change_in_bonuses.slice(*hard_caps.keys).each do |key, value|
      total_bonus_for_stat = total_item_bonuses.has_key?(key) ? total_item_bonuses[key] : 0.0
      if((value + total_bonus_for_stat) > hard_caps[key])
        bonuses_after_hard_cap[key] = [hard_caps[key] - total_bonus_for_stat, 0].max
      end
    end
    return change_in_bonuses.merge(bonuses_after_hard_cap)
  end
  
  def calculate_dps_change
    self.bonus_changes = stat_change_between(new_item, old_item)
    self.dps_change = character.dps_for(self.bonus_changes,self.for_pvp)
  end
  
  def new_item
    new_item_source.item
  end
  
  def wow_class
    character.wow_class
  end
  
  def new_item_source_type
    new_item_source.class.name.gsub(/Source/,"").downcase
  end

  def kind_of_change
    dps_change > 0 ? "upgrade" : "downgrade"
  end
end
