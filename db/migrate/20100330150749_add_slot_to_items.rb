class AddSlotToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :slot, :string
  end

  def self.down
    remove_column :items, :slot
  end
end
