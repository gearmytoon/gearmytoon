class CreatedSource < ItemSource
  has_many :items_made_from, :class_name => "ItemUsedToCreate", :foreign_key => :item_source_id
  belongs_to :trade_skill
end