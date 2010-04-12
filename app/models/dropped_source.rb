class DroppedSource < ItemSource
  named_scope :from_dungeons, Proc.new{{:conditions => {:source_area_id => Area.dungeons}}}
  named_scope :from_raids, Proc.new{{:conditions => {:source_area_id => Area.raids}}}
  belongs_to :source_area, :class_name => "Area"
end
