class ItemSource < ActiveRecord::Base
  named_scope :including_item, Proc.new {|conditions| {:include => :item, :conditions => conditions} }
  named_scope :usable_by, Proc.new {|wow_class|
    {:include => :item, :conditions => ["items.armor_type_id IN (?) AND items.restricted_to IN (?)", wow_class.usable_armor_types, [Item::RESTRICT_TO_NONE, wow_class.name]]}
  }
  belongs_to :item
end
