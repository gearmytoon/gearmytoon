class AddSlotToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :slot, :integer
  end

  def self.down
    remove_column :items, :slot
  end
end
