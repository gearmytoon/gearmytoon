class AddGmtScoreToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :gmt_score, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :characters, :gmt_score
  end
end
