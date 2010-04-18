class AddPlayersToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :players, :integer
  end

  def self.down
    remove_column :areas, :players
  end
end
