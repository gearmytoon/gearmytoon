class CharacterItem < ActiveRecord::Base
  include Gemable
  belongs_to :character
  belongs_to :item
  named_scope :equipped_on, Proc.new{|slot| {:include => :item, :conditions => ["items.slot = ?", slot]}}
  
  def bonuses
    item.bonuses.add_values(gem_bonuses)
  end
  
end
