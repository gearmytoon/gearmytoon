class MakeAllCharactersLowerCase < ActiveRecord::Migration
  def self.up
    Character.all.each do |character|
      character.update_attributes(:name => character.name.downcase, :realm => character.realm.downcase, :locale => character.locale.downcase)
    end
  end

  def self.down
  end
end
