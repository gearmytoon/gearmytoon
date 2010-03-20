class DungeonsController < ApplicationController
  # GET /zones
  # GET /zones.xml
  def index
    @character = Character.find(params[:character_id])
    @dungeons = Area.dungeons
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @zones }
    end
  end

end
