class AddIndexToItemsUsedToCreates < ActiveRecord::Migration
  def self.up
    add_index :item_used_to_creates, :item_source_id
  end

  def self.down
    remove_index :item_used_to_creates, :item_source_id
  end
end
