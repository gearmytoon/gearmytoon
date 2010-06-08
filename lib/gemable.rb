module Gemable

  def self.included(klass)
    klass.class_eval {
      belongs_to :gem_one, :class_name => "Item"
      belongs_to :gem_two, :class_name => "Item"
      belongs_to :gem_three, :class_name => "Item"
    }
  end
  def gems
    [gem_one, gem_two, gem_three].compact
  end
  
  def gem_bonuses
    gems.inject({}) do |memo, gem|
      memo.add_values(gem.bonuses)
    end
  end
  
end
