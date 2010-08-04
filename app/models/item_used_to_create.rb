class ItemUsedToCreate < ActiveRecord::Base
  belongs_to :item
  belongs_to :item_source
end
