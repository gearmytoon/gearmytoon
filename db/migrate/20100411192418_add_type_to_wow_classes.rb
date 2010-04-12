class AddTypeToWowClasses < ActiveRecord::Migration
  def self.up
    add_column :wow_classes, :type, :string
    add_index :wow_classes, :type
    add_index :wow_classes, :name
  end

  def self.down
    remove_index :wow_classes, :name
    remove_index :wow_classes, :type
    remove_column :wow_classes, :type
  end
end
