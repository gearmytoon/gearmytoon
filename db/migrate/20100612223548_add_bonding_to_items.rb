class AddBondingToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :bonding, :string
    add_index :items, :bonding
  end

  def self.down
    remove_index :items, :bonding
    remove_column :items, :bonding
  end
end
