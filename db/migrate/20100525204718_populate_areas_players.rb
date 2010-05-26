class PopulateAreasPlayers < ActiveRecord::Migration
  def self.up
    raids = Area.raids
    raids.map(&:determine_number_of_players)
    raids.map(&:save!)
  end

  def self.down
    Area.raids.map do |raid|
      raid.update_attribute :players, nil
    end
  end
end
