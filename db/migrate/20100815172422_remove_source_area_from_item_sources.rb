class RemoveSourceAreaFromItemSources < ActiveRecord::Migration
  def self.up
    remove_column :item_sources, :source_area_id
  end

  def self.down
    add_column :item_sources, :source_area_id, :integer
  end
end
