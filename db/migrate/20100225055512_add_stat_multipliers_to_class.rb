class AddStatMultipliersToClass < ActiveRecord::Migration
  def self.up
    add_column :wow_classes, :stat_multipliers, :text
  end

  def self.down
    remove_column :wow_classes, :stat_multipliers
  end
end
