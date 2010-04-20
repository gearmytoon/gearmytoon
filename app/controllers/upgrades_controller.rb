class UpgradesController < ApplicationController
  before_filter :assign_character

  def frost
    @upgrades = @character.frost_upgrades
    render "show"
  end
  
  def triumph
    @upgrades = @character.triumph_upgrades
    render "show"
  end
  
  def dungeon
    @upgrades = @character.heroic_dungeon_upgrades
    render "show"
  end

  def raid_25
    @upgrades = @character.raid_25_upgrades
    render "show"
  end

  def raid_10
    @upgrades = @character.raid_10_upgrades
    render "show"
  end
  
end
