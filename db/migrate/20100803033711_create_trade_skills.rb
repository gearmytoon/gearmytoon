class CreateTradeSkills < ActiveRecord::Migration
  def self.up
    create_table :trade_skills do |t|
      t.string :wowarmory_name
      t.timestamps
    end
  end

  def self.down
    drop_table :trade_skills
  end
end
