class AddIndexToSlot < ActiveRecord::Migration
  def self.up
    add_index :items, :slot
  end

  def self.down
    remove_index :items, :slot
  end
end
