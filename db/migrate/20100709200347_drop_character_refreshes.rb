class DropCharacterRefreshes < ActiveRecord::Migration
  def self.up
    drop_table :character_refreshes
  end

  def self.down
    create_table "character_refreshes", :force => true do |t|
      t.integer  "character_id"
      t.string   "status"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end
end
