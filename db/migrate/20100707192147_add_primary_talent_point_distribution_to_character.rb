class AddPrimaryTalentPointDistributionToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :active_talent_point_distribution, :string
  end

  def self.down
    remove_column :characters, :active_talent_point_distribution
  end
end
