class CharacterItem < ActiveRecord::Base
  belongs_to :character
  belongs_to :item
  named_scope :equipped_on, Proc.new{|slot| {:include => :item, :conditions => ["items.slot = ?", slot]}}
  belongs_to :gem_one, :class_name => "Item"
  belongs_to :gem_two, :class_name => "Item"
  belongs_to :gem_three, :class_name => "Item"
end
