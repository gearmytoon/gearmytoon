class CreateUpgrades < ActiveRecord::Migration
  def self.up
    create_table :upgrades, :force => true do |t|
      t.integer :character_id
      t.integer :old_item_id
      t.integer :new_item_source_id
      t.decimal :dps_change, :precision => 8, :scale => 2
      t.boolean :for_pvp
      t.text :bonus_changes
      t.timestamps
    end
  end

  def self.down
    drop_table :upgrades
  end
end
