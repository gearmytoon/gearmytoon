class AddCachedSlugToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :cached_slug, :string
  end

  def self.down
    remove_column :characters, :cached_slug
  end
end
