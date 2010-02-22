class CharactersController < ApplicationController
  
  def index
  end
  
  def create
    @character = Character.find_by_name_or_create_from_wowarmory(params[:character][:name])
    redirect_to character_path(@character)
  end
  
  def show
    @character = Character.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @character }
    end
  end

end
