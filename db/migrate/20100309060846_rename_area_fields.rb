class RenameAreaFields < ActiveRecord::Migration
  def self.up
    rename_column :items, :area_id, :source_area_id
    rename_column :areas, :wowarmory_id, :wowarmory_area_id
    remove_column :areas, :type
  end

  def self.down
    add_column :areas, :type, :string
    rename_column :areas, :wowarmory_area_id, :wowarmory_id
    rename_column :items, :source_area_id, :area_id
  end
end
