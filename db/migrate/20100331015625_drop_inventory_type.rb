class DropInventoryType < ActiveRecord::Migration
  def self.up
    remove_column :items, :inventory_type
  end

  def self.down
    add_column :items, :inventory_type, :integer
  end
end
