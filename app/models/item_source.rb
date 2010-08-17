class ItemSource < ActiveRecord::Base
  named_scope :including_item, :include => :item
  named_scope :also_include, Proc.new {|params| params}
  named_scope :unique_items, :group => :item_id
  named_scope :usable_by, Proc.new {|wow_class|
    {:include => :item, :conditions => ["items.armor_type_id IN (?) AND items.restricted_to IN (?)", wow_class.usable_armor_types, [Item::RESTRICT_TO_NONE, wow_class.name]]}
  }
  belongs_to :item
  has_many :upgrades, :foreign_key => "new_item_source_id", :dependent => :destroy


  def as_source_type
    self.class.name.gsub(/Source/,"").downcase
  end

  #purchased sources
  has_many :items_used_to_purchase, :class_name => "ItemUsedToCreate", :foreign_key => :item_source_id

  # dropped sources
  belongs_to :creature

  #purchase source, honor source, arena source
  belongs_to :vendor, :foreign_key => :creature_id, :class_name => "Creature"
  
  #quest_source
  belongs_to :quest
  
  #container_source
  belongs_to :container
end
