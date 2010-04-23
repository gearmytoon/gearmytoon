class UpgradesController < ApplicationController
  before_filter :assign_character

  def frost
    @kind_of_upgrade = "Emblem of Frost"
    @upgrades = @character.frost_upgrades
    render "show"
  end
  
  def triumph
    @kind_of_upgrade = "Emblem of Triumph"
    @upgrades = @character.triumph_upgrades
    render "show"
  end
  
  def dungeon
    @kind_of_upgrade = "Heroic Dungeon"
    @upgrades = @character.heroic_dungeon_upgrades
    render "show"
  end

  def raid_25
    @kind_of_upgrade = "25 man Raid"
    @upgrades = @character.raid_25_upgrades
    render "show"
  end

  def raid_10
    @kind_of_upgrade = "10 man Raid"
    @upgrades = @character.raid_10_upgrades
    render "show"
  end
  
end
