class Creature < ActiveRecord::Base
  belongs_to :area
  has_many :dropped_sources
  CLASSIFICATION_MAPPING = {"0" => "Normal", "1" => "Elite", "2" => "Rare Elite", "3" => "Boss"}

  named_scope :in_same_area, Proc.new {|creature| {:conditions => ["areas.wowarmory_area_id = ?", creature.area.wowarmory_area_id], :include => [:area]}}
  named_scope :unique_name, {:group => "creatures.name"}
  named_scope :that_are_bosses, :conditions => {:classification => "3"}
  named_scope :with_same_name, Proc.new{|creature|{:conditions => ["creatures.name = ?", creature.name]}}
  
  def humanize_classification
    CLASSIFICATION_MAPPING[classification]
  end
  
  def all_difficulties
    Creature.in_same_area(self).with_same_name(self)
  end
  
  def other_bosses_in_same_area
    Creature.in_same_area(self).that_are_bosses.unique_name
  end
  
  def level_range
    max_level == min_level ? max_level.to_s : "#{min_level}-#{max_level}"
  end
end
