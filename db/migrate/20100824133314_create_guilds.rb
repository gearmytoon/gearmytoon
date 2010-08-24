class CreateGuilds < ActiveRecord::Migration
  def self.up
    create_table :guilds do |t|
      t.string :name
      t.string :faction
      t.string :realm
      t.string :locale
      t.timestamps
    end
    add_column :characters, :guild_id, :integer
    remove_column :characters, :guild
    remove_column :characters, :guild_url
  end

  def self.down
    add_column :characters, :guild_url, :string
    add_column :characters, :guild, :string
    remove_column :characters, :guild_id
    drop_table :guilds
  end
end
