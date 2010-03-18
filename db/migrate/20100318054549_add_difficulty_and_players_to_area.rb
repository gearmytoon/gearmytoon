class AddDifficultyAndPlayersToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :difficulty, :string
  end

  def self.down
    remove_column :areas, :difficulty
  end
end
