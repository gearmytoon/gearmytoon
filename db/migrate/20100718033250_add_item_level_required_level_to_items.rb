class AddItemLevelRequiredLevelToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :item_level, :integer
    add_column :items, :required_level, :integer
  end

  def self.down
    remove_column :items, :required_level
    remove_column :items, :item_level
  end
end
