WowClassImporter.import_all_classes
MaxDpsImporter.new(:hunter).import_from_max_dps
MaxDpsImporter.new(:rogue).import_from_max_dps

dungeons = [206,4120,3477,4494,4196,4415,4375,4264,1196,4272,4228,4809,4813,4820,4723,4100]
raids = [4603,4273,4493,4500,2159,3456,4812,4722]

dungeons.each {|d| Dungeon.find_or_create_by_wowarmory_id(d)}
raids.each {|r| Raid.find_or_create_by_wowarmory_id(r)}
