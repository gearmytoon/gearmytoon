class AddSourceTypeAndSourceItemIdToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :source_type, :string
    add_column :items, :source_item_id, :integer
  end

  def self.down
    remove_column :items, :source_item_id
    remove_column :items, :source_type
  end
end
