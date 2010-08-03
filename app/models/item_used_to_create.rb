class ItemUsedToCreate < ActiveRecord::Base
  belongs_to :item_source
  belongs_to :currency_item, :foreign_key => :wowarmory_item_id, :primary_key => :wowarmory_item_id, :class_name => "Item"
end
