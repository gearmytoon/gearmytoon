class AddAreaIdToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :area_id, :integer
  end

  def self.down
    drop_column :items, :area_id
  end
end
