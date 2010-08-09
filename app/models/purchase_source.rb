class PurchaseSource < ItemSource
  has_many :items_made_from, :class_name => "ItemUsedToCreate", :foreign_key => :item_source_id
end
