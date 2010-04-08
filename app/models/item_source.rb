class ItemSource < ActiveRecord::Base
  belongs_to :item
  belongs_to :source_area, :class_name => "Area"
  named_scope :from_dungeons, Proc.new{{:conditions => {:source_area_id => Area.dungeons}}}
end
