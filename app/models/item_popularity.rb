class ItemPopularity < ActiveRecord::Base
  belongs_to :item
  belongs_to :wow_class
end
