class ItemPopularity < ActiveRecord::Base
  belongs_to :item
  belongs_to :spec
  has_one :wow_class, :through => :spec
end
