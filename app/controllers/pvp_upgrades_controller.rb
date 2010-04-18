class PvpUpgradesController < ApplicationController
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

  def honor_points
    @character = Character.find(params[:character_id])
    @upgrades = @character.honor_point_upgrades
    render "show"
  end
  
  def wintergrasp
    @character = Character.find(params[:character_id])
    @upgrades = @character.wintergrasp_mark_upgrades
    render "show"
  end
end
