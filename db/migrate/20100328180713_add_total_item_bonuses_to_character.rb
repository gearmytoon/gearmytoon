class AddTotalItemBonusesToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :total_item_bonuses, :text
  end

  def self.down
    remove_column :characters, :total_item_bonuses
  end
end
