class PvpUpgradesController < ApplicationController
  def from_honor_points
    @character = Character.find(params[:character_id])
  end
  
  def from_wintergrasp_marks
    @character = Character.find(params[:character_id])
  end
end
