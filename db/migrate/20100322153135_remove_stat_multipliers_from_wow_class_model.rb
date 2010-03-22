class RemoveStatMultipliersFromWowClassModel < ActiveRecord::Migration
  def self.up
    remove_column :wow_classes, :stat_multipliers
  end

  def self.down
    add_column :wow_classes, :stat_multipliers, :text
  end
end
