class CreateCharacterRefreshes < ActiveRecord::Migration
  def self.up
    create_table :character_refreshes do |t|
      t.integer :character_id
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :character_refreshes
  end
end
