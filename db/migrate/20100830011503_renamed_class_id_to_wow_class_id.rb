class RenamedClassIdToWowClassId < ActiveRecord::Migration
  def self.up
    rename_column :item_popularities, :class_id, :wow_class_id
    rename_column :item_popularities, :average_gearscore, :average_gmt_score
  end

  def self.down
    rename_column :item_popularities, :average_gmt_score, :average_gearscore
    rename_column :item_popularities, :wow_class_id, :class_id
  end
end
