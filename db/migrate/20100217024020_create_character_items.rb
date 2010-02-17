class CreateCharacterItems < ActiveRecord::Migration
  def self.up
    create_table :character_items do |t|
      t.integer :character_id
      t.integer :item_id
      t.timestamps
    end
  end

  def self.down
    drop_table :character_items
  end
end
