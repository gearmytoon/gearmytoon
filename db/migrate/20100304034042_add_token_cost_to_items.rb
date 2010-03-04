class AddTokenCostToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :token_cost, :integer
  end

  def self.down
    remove_column :items, :token_cost
  end
end
