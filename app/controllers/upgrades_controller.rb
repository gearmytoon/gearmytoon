class UpgradesController < ApplicationController
  def from_frost_emblems
    @character = Character.find(params[:character_id])
    @upgrades = @character.frost_upgrades
    render "show"
  end
  
  def from_triumph_emblems
    @character = Character.find(params[:character_id])
    @upgrades = @character.triumph_upgrades
    render "show"
  end
  
  def from_dungeons
    @character = Character.find(params[:character_id])
    @upgrades = @character.heroic_dungeon_upgrades
    render "show"
  end
  
end
