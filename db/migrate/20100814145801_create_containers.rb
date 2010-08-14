class CreateContainers < ActiveRecord::Migration
  def self.up
    create_table :containers do |t|
      t.string :name
      t.integer :wowarmory_container_id
      t.integer :area_id
      t.timestamps
    end
    add_column :item_sources, :container_id, :integer
    remove_column :item_sources, :wowarmory_container_id
    remove_column :item_sources, :name
    remove_column :item_sources, :heroic
  end

  def self.down
    remove_column :item_sources, :container_id
    add_column :item_sources, :heroic, :boolean,                  :default => false
    add_column :item_sources, :name, :string
    add_column :item_sources, :wowarmory_container_id, :integer
    drop_table :containers
  end
end
