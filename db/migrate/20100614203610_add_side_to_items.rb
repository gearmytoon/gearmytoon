class AddSideToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :side, :string
    Item.update_all(["side = ?", Item::ANY_SIDE])
  end

  def self.down
    remove_column :items, :side
  end
end
