class AddHeroicToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :heroic, :boolean, :default => 0
  end

  def self.down
    remove_column :items, :heroic
  end
end
