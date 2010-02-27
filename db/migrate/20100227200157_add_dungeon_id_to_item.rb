class AddDungeonIdToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :dungeon_id, :integer
  end

  def self.down
    remove_column :items, :dungeon_id
  end
end
