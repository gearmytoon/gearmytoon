class AddIconToItemDropSourceType < ActiveRecord::Migration
  def self.up
    add_column :items, :icon, :string
    remove_column :items, :source_type
  end

  def self.down
    add_column :items, :source_type, :string
    remove_column :items, :icon
  end
end
