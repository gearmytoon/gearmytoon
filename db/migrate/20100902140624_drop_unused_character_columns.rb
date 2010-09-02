class DropUnusedCharacterColumns < ActiveRecord::Migration
  def self.up
    remove_column :characters, :wow_class_id
    remove_column :characters, :primary_spec
  end

  def self.down
    add_column :characters, :primary_spec, :string
    add_column :characters, :wow_class_id, :integer
  end
end
