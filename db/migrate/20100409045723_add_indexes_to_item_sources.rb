class AddIndexesToItemSources < ActiveRecord::Migration
  def self.up
    add_index :item_sources, :type
    add_index :item_sources, :wowarmory_token_item_id
    add_index :item_sources, :source_area_id
    add_index :item_sources, :item_id
  end

  def self.down
    remove_index :item_sources, :item_id
    remove_index :item_sources, :source_area_id
    remove_index :item_sources, :wowarmory_token_item_id
    remove_index :item_sources, :type
  end
end
