class DropItemSourceInfoFromItemTable < ActiveRecord::Migration
  def self.up
    remove_index :items, :source_area_id
    remove_index :items, :source_wowarmory_item_id
    remove_column :items, :source_wowarmory_item_id
    remove_column :items, :token_cost
    remove_column :items, :source_area_id
    rename_column :item_sources, :wowarmory_item_id, :wowarmory_token_item_id
  end

  def self.down
    rename_column :item_sources, :wowarmory_token_item_id, :wowarmory_item_id
    add_column :items, :source_area_id, :integer
    add_column :items, :token_cost, :integer
    add_column :items, :source_wowarmory_item_id, :integer
    add_index :items, :source_area_id
    add_index :items, :source_wowarmory_item_id
  end
end
