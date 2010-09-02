class CreateSpecs < ActiveRecord::Migration
  def self.up
    create_table :specs do |t|
      t.integer :wow_class_id
      t.string :name
      t.timestamps
    end
    add_column :characters, :spec_id, :integer
  end

  def self.down
    remove_column :characters, :spec_id
    drop_table :specs
  end
end
