class GemItem < Item
  PURPLE = "Purple"
  RED = "Red"
  ORANGE = "Orange"
  PRISMATIC = "Prismatic"
  BLUE = "Blue"
  GREEN = "Green"
  YELLOW = "Yellow"
  META = "Meta"
  
  named_scope :usable_in_slot, Proc.new{|color| {:conditions => {:gem_color => GemItem.compatible_gem_colors(color)}}}
  
  def self.compatible_gem_colors(slot_color)
    case slot_color
    when "Any"
      [YELLOW, ORANGE, RED, PURPLE, BLUE, GREEN, PRISMATIC]
    when "Red"
      [PURPLE, RED, ORANGE, PRISMATIC]
    when "Yellow"
      [YELLOW, GREEN, ORANGE, PRISMATIC]
    when "Blue"
      [BLUE, GREEN, PURPLE, PRISMATIC]
    when "Meta"
      [META]
    else
      []
    end
  end
end