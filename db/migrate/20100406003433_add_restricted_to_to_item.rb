class AddRestrictedToToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :restricted_to, :string, :default => Item::RESTRICT_TO_NONE
    add_index :items, :restricted_to
    Item.update_all ["restricted_to = ?", Item::RESTRICT_TO_NONE]
  end

  def self.down
    remove_index :items, :restricted_to
    remove_column :items, :restricted_to
  end
end
