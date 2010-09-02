class ChangeItemPopularitiesToSpecId < ActiveRecord::Migration
  def self.up
    remove_column :item_popularities, :wow_class_id
    add_column :item_popularities, :spec_id, :integer
    remove_column :item_popularities, :spec
  end

  def self.down
    add_column :item_popularities, :spec, :string
    remove_column :item_popularities, :spec_id
    add_column :item_popularities, :wow_class_id, :integer
  end
end
