class AddUserIdToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :user_id, :integer
  end

  def self.down
    remove_column :characters, :user_id
  end
end
