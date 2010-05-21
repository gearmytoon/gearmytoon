class AddStatusToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :status, :string
  end

  def self.down
    remove_column :characters, :status
  end
end
