class AddGemColorToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :gem_color, :string
  end

  def self.down
    remove_column :items, :gem_color
  end
end
