class AddGemsToUpgrades < ActiveRecord::Migration
  def self.up
    add_column :upgrades, :gem_one_id, :integer
    add_column :upgrades, :gem_two_id, :integer
    add_column :upgrades, :gem_three_id, :integer
  end

  def self.down
    remove_column :upgrades, :gem_three_id
    remove_column :upgrades, :gem_two_id
    remove_column :upgrades, :gem_one_id
  end
end
