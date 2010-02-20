class AddBonusesToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :bonuses, :text
  end

  def self.down
    remove_column :items, :bonuses
  end
end
