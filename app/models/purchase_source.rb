class PurchaseSource < ItemSource
  has_many :items_made_from, :class_name => "ItemUsedToCreate", :foreign_key => :item_source_id
  belongs_to :vendor, :foreign_key => :creature_id, :class_name => "Creature"
end
