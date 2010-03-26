class AddIndexes < ActiveRecord::Migration
   
  def self.up
    add_index :items, :wowarmory_item_id
    add_index :items, :source_area_id
    add_index :items, :armor_type_id
    add_index :items, :inventory_type
    add_index :items, :source_wowarmory_item_id
    add_index :characters, :wow_class_id
    add_index :character_items, :character_id
    add_index :character_items, :item_id
    add_index :wow_classes, :primary_armor_type_id
    add_index :areas, :wowarmory_area_id
    add_index :characters, :name
    add_index :characters, [:name, :realm]
    add_index :characters, [:realm, :name]
  end

  def self.down
    remove_index :areas, :wowarmory_area_id
    remove_index :items, :source_area_id
    remove_index :items, :source_wowarmory_item_id
    remove_index :items, :inventory_type
    remove_index :items, :armor_type_id
    remove_index :items, :wowarmory_item_id
    remove_index :characters, :wow_class_id
    remove_index :character_items, :character_id
    remove_index :character_items, :item_id
    remove_index :wow_classes, :primary_armor_type_id
    remove_index :characters, :name
    remove_index :characters, :column => [:name, :realm]
    remove_index :characters, :column => [:realm, :name]
  end
  
end
