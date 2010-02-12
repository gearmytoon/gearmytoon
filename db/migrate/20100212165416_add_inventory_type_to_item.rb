class AddInventoryTypeToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :inventory_type, :integer
    remove_column :items, :quality
    add_column :items, :quality, :integer
  end

  def self.down
    remove_column :items, :quality
    add_column :items, :quality, :string
    remove_column :items, :inventory_type
  end
end
