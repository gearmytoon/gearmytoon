class AddCachedSlugToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :cached_slug, :string
  end

  def self.down
    remove_column :items, :cached_slug
  end
end
