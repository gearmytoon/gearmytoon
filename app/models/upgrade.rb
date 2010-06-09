class Upgrade < ActiveRecord::Base
  include Gemable
  serialize :bonus_changes
  belongs_to :character
  belongs_to :old_character_item, :class_name => "CharacterItem"
  belongs_to :new_item_source, :class_name => "ItemSource"
  named_scope :with_sources, Proc.new {|conditions|
    {:include => [{:old_character_item => :item}, {:new_item_source => :item}], :conditions => conditions}
  }
  named_scope :pvp, lambda { |for_pvp| { :conditions => {:for_pvp => for_pvp} } }
  named_scope :order_by_dps,  :order => "dps_change DESC"
  named_scope :limited, lambda { |num| { :limit => num } }

  before_create :calculate_dps_change
  before_create :find_best_gems
  
  def calculate_dps_change
    self.bonus_changes = apply_hard_caps(change_in_stats)
    self.dps_change = character.dps_for(self.bonus_changes,self.for_pvp)
  end
  
  def find_best_gems
    gem_slots = ["gem_one", "gem_two", "gem_three"]
    if new_item.gem_sockets
      new_item.gem_sockets.each_with_index do |socket_color, index|
        self.send("#{gem_slots[index]}=",character.find_best_gem(self.for_pvp))
      end
    end
  end
  
  def change_in_stats
    new_item_total_bonuses.subtract_values(old_character_item.bonuses)
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
  
  def new_item
    new_item_source.item
  end

  def new_item_total_bonuses
    new_item.bonuses.add_values(gem_bonuses)
  end
  
  def wow_class
    character.wow_class
  end

  def old_item
    old_character_item.item
  end
  
  def new_item_source_type
    new_item_source.class.name.gsub(/Source/,"").downcase
  end

  def kind_of_change
    dps_change > 0 ? "upgrade" : "downgrade"
  end
  
end
