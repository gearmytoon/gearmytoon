class CharactersController < ApplicationController
  
  def index
  end
  
  def show
    @character = Character.find_by_name(params[:id])
    # @character = Character.first
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @character }
    end
  end

end
