require 'wowr'
WowClassImporter.import_all_classes
FromTextFileItemImporter.import!("#{RAILS_ROOT}/db/data/items/hunter.txt")
FromTextFileItemImporter.import!("#{RAILS_ROOT}/db/data/items/rogue.txt")
ItemImporter.import_from_wowarmory!(Item::FROST_EMBLEM_ARMORY_ID)
ItemImporter.import_from_wowarmory!(Item::TRIUMPH_EMBLEM_ARMORY_ID)
ItemImporter.import_from_wowarmory!(Item::WINTERGRASP_MARK_OF_HONOR)
