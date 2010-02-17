class AddNameAndRealmToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :name, :string
    add_column :characters, :realm, :string
  end

  def self.down
    remove_column :characters, :realm
    remove_column :characters, :name
  end
end
