class Area < ActiveRecord::Base
  HEROIC = 'h'
  NORMAL = 'n'
  DUNGEONS = [206,4120,3477,4494,4196,4415,4375,4264,1196,4272,4228,4809,4813,4820,4723,4100]
  RAIDS = [4603,4273,4493,4500,2159,3456,4812,4722,4987]

  named_scope :dungeons, :conditions => {:wowarmory_area_id => DUNGEONS}
  named_scope :raids, :conditions => {:wowarmory_area_id => RAIDS}
  named_scope :raids_10, :conditions => {:wowarmory_area_id => RAIDS, :players => 10}
  named_scope :raids_25, :conditions => {:wowarmory_area_id => RAIDS, :players => 25}
  has_many :dropped_sources, :foreign_key => :source_area_id
  
  def full_name
    [difficulty_as_word, name].compact.join(" ")
  end
  
  def difficulty_players
    [full_difficulty_as_word, players].join(" ")
  end
  
  def simplified_name
    name.gsub(/[\(\d\)]/,"").strip
  end
  
  def full_difficulty_as_word
    difficulty == HEROIC ? "Heroic" : "Normal"
  end
  
  def difficulty_as_word
    difficulty == HEROIC ? "Heroic" : nil
  end
  
  before_create :determine_number_of_players
  def determine_number_of_players
    if name.match(/(\d+)/)
      self.players = $1
    else
      self.players = self.difficulty == HEROIC ? '25' : '10'
    end
  end
end
