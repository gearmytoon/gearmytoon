class DropSlotFromItem < ActiveRecord::Migration
  def self.up
    remove_column :items, :slot
  end

  def self.down
    add_column :items, :slot, :integer
  end
end
