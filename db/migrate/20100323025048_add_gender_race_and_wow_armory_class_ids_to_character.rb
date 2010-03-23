class AddGenderRaceAndWowArmoryClassIdsToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :wowarmory_gender_id, :integer
    add_column :characters, :gender, :string
    add_column :characters, :wowarmory_race_id, :integer
    add_column :characters, :race, :string
    add_column :characters, :wowarmory_class_id, :integer
  end

  def self.down
    remove_column :characters, :wowarmory_class_id
    remove_column :characters, :race
    remove_column :characters, :wowarmory_race_id
    remove_column :characters, :gender
    remove_column :characters, :wowarmory_gender_id
  end
end
