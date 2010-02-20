class RemoveDpsFromItem < ActiveRecord::Migration
  def self.up
    remove_column :items, :dps
  end

  def self.down
    add_column :items, :dps, :decimal
  end
end
