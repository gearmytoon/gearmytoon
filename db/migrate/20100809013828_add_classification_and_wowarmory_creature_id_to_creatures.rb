class AddClassificationAndWowarmoryCreatureIdToCreatures < ActiveRecord::Migration
  def self.up
    add_column :creatures, :classification, :string
    add_column :creatures, :creature_type, :string
    add_column :creatures, :wowarmory_creature_id, :integer
    add_column :creatures, :min_level, :integer
    add_column :creatures, :max_level, :integer
  end

  def self.down
    remove_column :creatures, :max_level
    remove_column :creatures, :min_level
    remove_column :creatures, :wowarmory_creature_id
    remove_column :creatures, :creature_type
    remove_column :creatures, :classification
  end
end
