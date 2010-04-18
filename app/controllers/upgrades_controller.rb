class UpgradesController < ApplicationController
  def frost
    @character = Character.find(params[:character_id])
    @upgrades = @character.frost_upgrades
    render "show"
  end
  
  def triumph
    @character = Character.find(params[:character_id])
    @upgrades = @character.triumph_upgrades
    render "show"
  end
  
  def dungeon
    @character = Character.find(params[:character_id])
    @upgrades = @character.heroic_dungeon_upgrades
    render "show"
  end
  
end
