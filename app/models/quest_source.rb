class QuestSource < ItemSource
  belongs_to :source_area, :class_name => "Area"
end