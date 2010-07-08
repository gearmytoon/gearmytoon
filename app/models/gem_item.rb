class GemItem < Item
  PURPLE = "Purple"
  RED = "Red"
  ORANGE = "Orange"
  PRISMATIC = "Prismatic"
  BLUE = "Blue"
  GREEN = "Green"
  YELLOW = "Yellow"
  META = "Meta"
  ALL_COLORS = [PURPLE, RED, ORANGE, PRISMATIC, BLUE, GREEN, YELLOW, META]
  
  named_scope :with_color, Proc.new{|color| {:conditions => {:gem_color => color, :bonding => Item::BOE}}}
  
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
  
  def self.beta_gem?(gem_item)
    gem_item.gem_color == META
  end
end