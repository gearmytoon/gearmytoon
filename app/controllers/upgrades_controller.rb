class UpgradesController < ApplicationController
  before_filter :assign_character

  def frost
    @kind_of_upgrade = "Emblem of Frost"
    @upgrades = @character.frost_upgrades(params[:page])
    render "show"
  end
  
  def triumph
    @kind_of_upgrade = "Emblem of Triumph"
    @upgrades = @character.triumph_upgrades(params[:page])
    render "show"
  end
  
  def dungeon
    @kind_of_upgrade = "Heroic Dungeon"
    @upgrades = @character.heroic_dungeon_upgrades(params[:page])
    render "show"
  end

  def raid_25
    @raids = Area.raids_25
    render "raids"
  end

  def raid_10
    @raids = Area.raids_10
    render "raids"
  end
  
end
