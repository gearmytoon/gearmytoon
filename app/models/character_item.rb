class CharacterItem < ActiveRecord::Base
  include Gemable
  belongs_to :character
  belongs_to :item
  named_scope :equipped_on, Proc.new{|slot| {:include => :item, :conditions => ["items.slot = ?", slot]}}
  named_scope :used_by, Proc.new{|spec| {:joins => :character, :conditions => ["characters.spec_id = ?", spec.id]}}
  
  def bonuses
    item.bonuses.add_values(gem_bonuses)
  end
  
end
