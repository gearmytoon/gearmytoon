class CreateArmorTypes < ActiveRecord::Migration
  def self.up
    create_table :armor_types do |t|
      t.string :name
      t.timestamps
    end
    remove_column :items, :armor_type
    add_column :items, :armor_type_id, :integer
    add_column :wow_classes, :primary_armor_type_id, :integer
  end

  def self.down
    remove_column :wow_classes, :armor_type_id
    remove_column :items, :armor_type_id
    add_column :items, :armor_type, :string
    drop_table :armor_types
  end
end
