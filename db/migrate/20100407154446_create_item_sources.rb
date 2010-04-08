class CreateItemSources < ActiveRecord::Migration
  def self.up
    create_table :item_sources do |t|
      t.string :type
      t.integer :arena_point_cost
      t.integer :honor_point_cost
      t.integer :wowarmory_item_id
      t.integer :token_cost
      t.integer :source_area_id
      t.integer :item_id
      t.timestamps
    end
  end

  def self.down
    drop_table :item_sources
  end
end
