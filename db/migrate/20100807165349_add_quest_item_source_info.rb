class AddQuestItemSourceInfo < ActiveRecord::Migration
  def self.up
    add_column :item_sources, :level, :integer
    add_column :item_sources, :name, :string
    add_column :item_sources, :required_min_level, :integer
    add_column :item_sources, :suggested_party_size, :string
    add_column :item_sources, :wowarmory_quest_id, :integer
  end

  def self.down
    remove_column :item_sources, :wowarmory_quest_id
    remove_column :item_sources, :suggested_party_size
    remove_column :item_sources, :required_min_level
    remove_column :item_sources, :name
    remove_column :item_sources, :level
  end
end
