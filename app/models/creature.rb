class Creature < ActiveRecord::Base
  belongs_to :area
  has_many :dropped_sources
  CLASSIFICATION_MAPPING = {"0" => "Normal", "1" => "Elite", "2" => "Rare Elite", "3" => "Boss"}

  def humanize_classification
    CLASSIFICATION_MAPPING[classification]
  end
end
