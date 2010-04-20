class DroppedSource < ItemSource
  named_scope :from_dungeons, Proc.new{{:conditions => {:source_area_id => Area.dungeons}}}
  named_scope :from_raids_10, Proc.new{{:conditions => {:source_area_id => Area.raids_10}}}
  named_scope :from_raids_25, Proc.new{{:conditions => {:source_area_id => Area.raids_25}}}
  belongs_to :source_area, :class_name => "Area"
end
