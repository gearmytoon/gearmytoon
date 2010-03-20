class UpgradesController < ApplicationController
  def from_frost_emblems
    @character = Character.find(params[:character_id])
    respond_to do |format|
      format.html
    end
  end
  
  def from_triumph_emblems
    @character = Character.find(params[:character_id])
    respond_to do |format|
      format.html
    end
  end
  
  def from_dungeons
    @character = Character.find(params[:character_id])
    respond_to do |format|
      format.html
    end
  end
end
