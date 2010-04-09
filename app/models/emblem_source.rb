class EmblemSource < ItemSource
  named_scope :from_emblem_of_triumph, :conditions => {:wowarmory_token_item_id => Item::TRIUMPH_EMBLEM_ARMORY_ID}
  named_scope :from_emblem_of_frost, :conditions => {:wowarmory_token_item_id => Item::FROST_EMBLEM_ARMORY_ID}
end
