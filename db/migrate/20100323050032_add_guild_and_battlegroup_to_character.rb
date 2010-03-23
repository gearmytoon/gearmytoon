class AddGuildAndBattlegroupToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :guild, :string
    add_column :characters, :battle_group, :string
    add_column :characters, :guild_url, :string
  end

  def self.down
    remove_column :characters, :guild_url
    remove_column :characters, :battle_group
    remove_column :characters, :guild
  end
end
