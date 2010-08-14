class CreateItemPopularities < ActiveRecord::Migration
  def self.up
    create_table :item_popularities do |t|
      t.integer :class_id
      t.string :spec
      t.decimal :percentage
      t.integer :item_id
      t.integer :average_gearscore

      t.timestamps
    end
  end

  def self.down
    drop_table :item_popularities
  end
end
