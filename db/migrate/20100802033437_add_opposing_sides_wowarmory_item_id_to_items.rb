class AddOpposingSidesWowarmoryItemIdToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :opposing_sides_wowarmory_item_id, :integer
  end

  def self.down
    remove_column :items, :opposing_sides_wowarmory_item_id
  end
end
