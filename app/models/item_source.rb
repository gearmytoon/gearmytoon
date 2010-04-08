class ItemSource < ActiveRecord::Base
  belongs_to :item
end

class DroppedSource < ItemSource
  named_scope :from_dungeons, Proc.new{{:conditions => {:source_area_id => Area.dungeons}}}
  belongs_to :source_area, :class_name => "Area"
end

class EmblemSource < ItemSource
end
