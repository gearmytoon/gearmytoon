class AddSocketBonusToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :socket_bonuses, :text
  end

  def self.down
    remove_column :items, :socket_bonuses
  end
end
