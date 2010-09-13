class ItemPopularity < ActiveRecord::Base
  belongs_to :item
  belongs_to :spec
  has_one :wow_class, :through => :spec
  
  def params_to_post
    {:average_gmt_score => self.average_gmt_score.to_s, :percentage => self.percentage.to_s, :spec_name => spec.name, :wow_class_name => wow_class.name}
  end
end
