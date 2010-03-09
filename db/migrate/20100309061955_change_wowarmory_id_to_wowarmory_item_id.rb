class ChangeWowarmoryIdToWowarmoryItemId < ActiveRecord::Migration
  def self.up
    rename_column :items, :wowarmory_id, :wowarmory_item_id
    rename_column :items, :source_item_id, :source_wowarmory_item_id
  end

  def self.down
    rename_column :items, :source_wowarmory_item_id, :source_item_id
    rename_column :items, :wowarmory_item_id, :wowarmory_id
  end
end
