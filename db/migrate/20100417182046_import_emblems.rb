class ImportEmblems < ActiveRecord::Migration
  def self.up
    ItemImporter.import_from_wowarmory!(Item::FROST_EMBLEM_ARMORY_ID)
    ItemImporter.import_from_wowarmory!(Item::TRIUMPH_EMBLEM_ARMORY_ID)
    ItemImporter.import_from_wowarmory!(Item::WINTERGRASP_MARK_OF_HONOR)
  end
  def self.down
  end
end
