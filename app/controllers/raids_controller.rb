class RaidsController < ApplicationController
  # GET /zones
  # GET /zones.xml
  def index
    @character = Character.find(params[:character_id])
    @raids = Area.raids
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /zones/1
  # GET /zones/1.xml
  def show
    @character = Character.find(params[:character_id])
    @raid = Area.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
  