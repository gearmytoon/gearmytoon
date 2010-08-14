class CreateQuests < ActiveRecord::Migration
  def self.up
    create_table :quests do |t|
      t.string :name
      t.integer :wowarmory_quest_id
      t.integer :required_min_level
      t.string :suggested_party_size
      t.integer :level
      t.integer :area_id
      t.timestamps
    end
    add_column :item_sources, :quest_id, :integer
    remove_column :item_sources, :wowarmory_quest_id
    remove_column :item_sources, :suggested_party_size
    remove_column :item_sources, :required_min_level
    remove_column :item_sources, :level
  end

  def self.down
    remove_column :item_sources, :quest_id
    add_column :item_sources, :wowarmory_quest_id, :integer
    add_column :item_sources, :level, :integer
    add_column :item_sources, :required_min_level, :integer
    add_column :item_sources, :suggested_party_size, :string
    drop_table :quests
  end
end
