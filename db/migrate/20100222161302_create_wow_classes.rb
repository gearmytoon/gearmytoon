class CreateWowClasses < ActiveRecord::Migration
  def self.up
    create_table :wow_classes do |t|
      t.string :name
      t.timestamps
    end
    add_column :characters, :wow_class_id, :integer
  end

  def self.down
    remove_column :characters, :wow_class_id
    drop_table :wow_classes
  end
end
