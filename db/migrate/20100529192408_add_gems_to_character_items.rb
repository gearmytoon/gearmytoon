class AddGemsToCharacterItems < ActiveRecord::Migration
  def self.up
    add_column :character_items, :gem_one_id, :integer
    add_column :character_items, :gem_two_id, :integer
    add_column :character_items, :gem_three_id, :integer
  end

  def self.down
    remove_column :character_items, :gem_one_id
    remove_column :character_items, :gem_two_id
    remove_column :character_items, :gem_three_id
  end
end
