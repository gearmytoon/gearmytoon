class AddAverageGmtScoreToSpec < ActiveRecord::Migration
  def self.up
    add_column :specs, :average_gmt_score, :integer
    add_column :specs, :gmt_score_standard_deviation, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :specs, :gmt_score_standard_deviation
    remove_column :specs, :average_gmt_score
  end
end
