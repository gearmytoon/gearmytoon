class AddPrimarySpecToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :primary_spec, :string
  end

  def self.down
    remove_column :characters, :primary_spec
  end
end
