class AddGemSocketsToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :gem_sockets, :text
  end

  def self.down
    remove_column :items, :gem_sockets
  end
end
