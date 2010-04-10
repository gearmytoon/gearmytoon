class AddLocaleToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :locale, :string
  end

  def self.down
    remove_column :characters, :locale
  end
end
