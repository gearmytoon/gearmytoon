class CharactersController < ApplicationController
  helper :areas
  before_filter :require_admin, :only => :index

  before_filter :assign_character, :only => [:show, :pvp]
  before_filter :redirect_to_current_url, :only => :show

  def index
    @characters = Character.all
  end

  def create
    begin
      @character = Character.find_or_create(params[:character][:name],params[:character][:realm],params[:character][:locale])
      if @character.valid?
        @character.initial_import_in_background!
        current_user.user_characters.find_or_create_by_character_id(:character_id => @character.id) if current_user
        redirect_to character_path(@character)
      else
        @user = current_user
        render 'users/show'
      end
    end
  end

  def not_found
    @character = Character.find(params[:id])
  end

  def show
    @title = "#{@character.name.capitalize} of #{@character.realm.capitalize}"
  end

  def pvp
  end

  def status
    character = Character.find(params[:id])
    respond_to do |format|
      format.json do
        render :json => {:status => character.status}
      end
    end
  end

  private
  def redirect_to_current_url
    redirect_to(@character, :status => :moved_permanently) unless @character.friendly_id_status.best?
  end
end
