class Area < ActiveRecord::Base
  DUNGEONS = [206,4120,3477,4494,4196,4415,4375,4264,1196,4272,4228,4809,4813,4820,4723,4100]
  RAIDS = [4603,4273,4493,4500,2159,3456,4812,4722]

  TYPES = ['Area','Dungeon','Raid']

  named_scope :dungeons, :conditions => {:wowarmory_id => DUNGEONS}
  named_scope :raids, :conditions => {:wowarmory_id => RAIDS}
end
