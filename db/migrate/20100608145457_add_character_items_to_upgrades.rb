class AddCharacterItemsToUpgrades < ActiveRecord::Migration
  def self.up
    add_column :upgrades, :old_character_item_id, :integer
    remove_column :upgrades, :old_item_id
  end

  def self.down
    add_column :upgrades, :old_item_id, :integer
    remove_column :upgrades, :old_character_item_id
  end
end
