class CharactersController < ApplicationController
  layout 'characters'
  helper :areas

  def index
    @character = Character.new(:realm => "Baelgun")
  end

  def create
    @character = Character.find_by_name_and_realm_or_create_from_wowarmory(params[:character][:name].capitalize, params[:character][:realm].capitalize)
    if current_user
      @character.user = current_user
      @character.save
      flash[:notice] = "Toon added successfully!"
      redirect_to account_url and return
    end
    redirect_to character_path(@character)
    rescue Wowr::Exceptions::CharacterNotFound
      redirect_to no_such_character_home_path(:name => params[:character][:name].capitalize, :realm => params[:character][:realm].capitalize)
  end

  def show
    @character = Character.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @character }
    end
  end

end
