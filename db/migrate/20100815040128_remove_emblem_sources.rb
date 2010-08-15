class RemoveEmblemSources < ActiveRecord::Migration
  def self.up
    remove_column :item_sources, :wowarmory_token_item_id
    remove_column :item_sources, :token_cost
  end

  def self.down
    add_column :item_sources, :token_cost, :integer
    add_column :item_sources, :wowarmory_token_item_id, :integer
  end
end
