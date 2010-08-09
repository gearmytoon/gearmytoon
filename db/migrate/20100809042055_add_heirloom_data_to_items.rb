class AddHeirloomDataToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :required_level_min, :integer
    add_column :items, :required_level_max, :integer
    add_column :items, :account_bound, :boolean
  end

  def self.down
    remove_column :items, :account_bound
    remove_column :items, :required_level_max
    remove_column :items, :required_level_min
  end
end
