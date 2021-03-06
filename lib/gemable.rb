module Gemable

  def self.included(klass)
    klass.class_eval {
      belongs_to :gem_one, :class_name => "GemItem"
      belongs_to :gem_two, :class_name => "GemItem"
      belongs_to :gem_three, :class_name => "GemItem"
    }
  end
  
  def gems
    [gem_one, gem_two, gem_three].compact
  end
  
  def gem_bonuses
    gems.sum_bonuses
  end
  
end
