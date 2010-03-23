class AddLevelToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :level, :integer
  end

  def self.down
    remove_column :characters, :level
  end
end
