class Creature < ActiveRecord::Base
  belongs_to :area
  has_many :dropped_sources
  CLASSIFICATION_MAPPING = {"0" => "Normal", "1" => "Elite", "2" => "Rare Elite", "3" => "Boss"}
  
  def humanize_classification
    CLASSIFICATION_MAPPING[classification]
  end
  
  def all_difficulties
    Creature.all(:conditions => ["creatures.name = ? AND areas.wowarmory_area_id = ?",self.name, self.area.wowarmory_area_id], :include => [:area, {:dropped_sources => :item}])
  end
  
  def other_creatures_in_same_area
    Creature.all(:conditions => ["areas.wowarmory_area_id = ?", self.area.wowarmory_area_id], :include => [:area], :group => "creatures.name")
  end
end
