class AddIndexesToUpgrades < ActiveRecord::Migration
  def self.up
    add_index :upgrades, :character_id
    add_index :upgrades, :new_item_source_id
    add_index :upgrades, [:character_id, :new_item_source_id]
  end

  def self.down
    remove_index :upgrades, [:character_id, :new_item_source_id]
    remove_index :upgrades, :new_item_source_id
    mind
    remove_index :upgrades, :character_id
  end
end
