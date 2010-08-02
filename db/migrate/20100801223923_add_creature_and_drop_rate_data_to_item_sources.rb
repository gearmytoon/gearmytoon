class AddCreatureAndDropRateDataToItemSources < ActiveRecord::Migration
  def self.up
    add_column :item_sources, :drop_rate, :string
    add_column :item_sources, :heroic, :boolean, :default => 0
    add_column :item_sources, :creature_id, :integer
    create_table :creatures, :force => true do |t|
      t.string :name
      t.integer :area_id
      t.timestamps
    end
  end

  def self.down
    drop_table :creatures
    remove_column :item_sources, :creature_id
    remove_column :item_sources, :heroic
    remove_column :item_sources, :drop_rate
  end
end
