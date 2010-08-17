class PurchaseSource < ItemSource
  belongs_to :item
  belongs_to :vendor, :foreign_key => :creature_id, :class_name => "Creature"
end
