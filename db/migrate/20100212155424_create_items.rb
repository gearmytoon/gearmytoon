class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items, :force => true do |t|
      t.string :name
      t.integer :wowarmory_id
      t.decimal :dps, :precision => 6, :scale => 2
      t.string :quality
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
