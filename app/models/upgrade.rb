class Upgrade < ActiveRecord::Base
  include Gemable
  cattr_reader :per_page
  @@per_page = 12
  serialize :bonus_changes
  belongs_to :character
  belongs_to :old_character_item, :class_name => "CharacterItem"
  belongs_to :new_item_source, :class_name => "ItemSource"
  belongs_to :purchase_source, :class_name => "PurchaseSource", :foreign_key => "new_item_source_id"
  belongs_to :dropped_source, :class_name => "DroppedSource", :foreign_key => "new_item_source_id"
  
  named_scope :with_sources, {:include => [:gem_one, :gem_two, :gem_three, 
                                          {:old_character_item => [:item, :gem_one, :gem_two, :gem_three]}, 
                                          {:new_item_source => [:item, {:items_used_to_purchase => :currency_item}, {:creature => :area}]}]}
  named_scope :also_include, Proc.new {|params| params}
  named_scope :limit_to_type, Proc.new {|source_item_type| {:conditions => ['item_sources.type = ?', source_item_type.name]}}
  named_scope :pvp, lambda { |for_pvp| { :conditions => {:for_pvp => for_pvp} } }
  named_scope :order_by_dps,  :order => "dps_change DESC"
  named_scope :limited, lambda { |num| { :limit => num } }
  
  before_create :find_best_gems
  before_create :calculate_dps_change
  
  def calculate_dps_change
    self.bonus_changes = character.apply_hard_caps(change_in_stats)
    self.dps_change = character.dps_for(self.bonus_changes,self.for_pvp)
  end
  
  def new_item_sockets
    sockets = new_item.gem_sockets_with_nil_protection
    new_item.is_a_belt? ? (sockets + ["Any"]) : sockets
  end
  
  def find_best_gems
    gem_slots = ["gem_one", "gem_two", "gem_three"]
    if new_item_sockets
      best_gems_matching_sockets = find_best_gems_matching_sockets
      best_gems_not_matching_sockets = find_best_gems_not_matching_sockets
      matching_gems_dps = character.dps_for_after_hard_caps(best_gems_matching_sockets.sum_bonuses.add_values(new_item.socket_bonuses), self.for_pvp)
      not_matching_gems_dps = character.dps_for_after_hard_caps(best_gems_not_matching_sockets.sum_bonuses,self.for_pvp)
      gems = (matching_gems_dps > not_matching_gems_dps) ? best_gems_matching_sockets : best_gems_not_matching_sockets
      gems.each_with_index do |gem_item, index|
        self.send("#{gem_slots[index]}=",gem_item)
      end
    end
  end
  
  def find_best_gems_not_matching_sockets
    best_gem = character.find_best_gem("Any", new_item.bonuses, self.for_pvp)
    new_item_sockets.map do |socket_color|
      if socket_color == "Meta"
        character.find_best_gem(socket_color, new_item.bonuses, self.for_pvp)
      else
        best_gem
      end
    end
  end
  
  def find_best_gems_matching_sockets
    matching_gems = new_item_sockets.map do |socket_color|
      character.find_best_gem(socket_color, new_item.bonuses, self.for_pvp)
    end
  end
  
  def change_in_stats
    new_item_total_bonuses.subtract_values(old_character_item.bonuses)
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
    new_item_source.as_source_type
  end

  def kind_of_change
    dps_change > 0 ? "upgrade" : "downgrade"
  end
  
end
