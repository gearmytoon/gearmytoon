class AddSubscriberAndCharacterToUserCharacters < ActiveRecord::Migration
  def self.up
    add_column :user_characters, :subscriber_id, :integer
    add_column :user_characters, :character_id, :integer
    add_index :user_characters, :subscriber_id
    add_index :user_characters, :character_id
  end

  def self.down
    remove_index :user_characters, :character_id
    remove_index :user_characters, :subscriber_id
    mind
    remove_column :user_characters, :character_id
    remove_column :user_characters, :subscriber_id
  end
end
