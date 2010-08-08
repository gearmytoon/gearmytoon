class AddWowarmoryContainerIdToItemSource < ActiveRecord::Migration
  def self.up
    add_column :item_sources, :wowarmory_container_id, :integer
  end

  def self.down
    remove_column :item_sources, :wowarmory_container_id
  end
end
