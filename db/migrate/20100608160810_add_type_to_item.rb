class AddTypeToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :type, :string
    add_index :items, :type
  end

  def self.down
    remove_index :items, :type
    remove_column :items, :type
  end
end
