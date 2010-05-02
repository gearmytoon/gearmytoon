class CreateUserCharacters < ActiveRecord::Migration
  def self.up
    create_table :user_characters do |t|
      t.subscriber_id :integer
      t.character_id :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :user_characters
  end
end
