class AddArmorTypeToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :armor_type, :string
  end

  def self.down
    remove_column :items, :armor_type
  end
end
