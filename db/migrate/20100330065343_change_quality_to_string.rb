class ChangeQualityToString < ActiveRecord::Migration
  def self.up
    remove_column :items, :quality
    add_column :items, :quality, :string
  end

  def self.down
    remove_column :items, :quality
    add_column :items, :quality, :integer
  end
end
