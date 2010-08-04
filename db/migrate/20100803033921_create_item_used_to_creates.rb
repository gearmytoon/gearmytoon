class CreateItemUsedToCreates < ActiveRecord::Migration
  def self.up
    create_table :item_used_to_creates do |t|
      t.integer :wowarmory_item_id
      t.integer :item_source_id
      t.integer :quantity
      t.timestamps
    end
  end

  def self.down
    drop_table :item_used_to_creates
  end
end
