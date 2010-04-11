class UpgradesController < ApplicationController
  def from_frost_emblems
    @character = Character.find(params[:character_id])
  end
  
  def from_triumph_emblems
    @character = Character.find(params[:character_id])
  end
  
  def from_dungeons
    @character = Character.find(params[:character_id])
  end
  
  def from_honor_points
    @character = Character.find(params[:character_id])
  end
  
  def from_wintergrasp_marks
    @character = Character.find(params[:character_id])
  end
end
