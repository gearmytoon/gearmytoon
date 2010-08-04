class AddTradeSkillIdToItemSources < ActiveRecord::Migration
  def self.up
    add_column :item_sources, :trade_skill_id, :string
  end

  def self.down
    remove_column :item_sources, :trade_skill_id
  end
end
