class AddFreeSupportToAccount < ActiveRecord::Migration
  def self.up
    add_column :users, :free_access, :boolean
  end

  def self.down
    remove_column :users, :free_access
  end
end
