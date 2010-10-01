class AddCreatureIndexToItemSources < ActiveRecord::Migration
  def self.up
    add_index :item_sources, :creature_id
  end

  def self.down
    remove_index :item_sources, :creature_id
  end
end
