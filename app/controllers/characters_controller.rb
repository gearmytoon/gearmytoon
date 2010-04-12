class CharactersController < ApplicationController
  helper :areas
  before_filter :require_user, :except => [:show, :pvp]
  before_filter :require_admin, :only => :index
  before_filter :redirect_to_current_url, :only => :show

  def index
    @characters = Character.all
  end

  def create
    if c = Character.find_by_name_and_realm_and_locale(params[:character][:name].upcase,params[:character][:realm].upcase,params[:character][:locale])
      redirect_to character_path(c)
    else
      begin
        @character = Character.new(params[:character])
        @character.user = current_user
        @character = CharacterImporter.import_character_and_all_items(@character) if @character.valid?
        if @character.save
          flash[:notice] = "Toon added successfully!"
          redirect_to character_path(@character)
        else
          @user = @current_user
          render 'users/show'
        end
      rescue Wowr::Exceptions::CharacterNotFound
        render "#{RAILS_ROOT}/public/404.html", :status => 404
      end
    end
  end

  def show
    @character = Character.find(params[:id])
    CharacterImporter.refresh_character!(@character)
  end
  
  def pvp
    @character = Character.find(params[:id])
  end

  private
  def redirect_to_current_url
    @character = Character.find(params[:id])
    redirect_to @character, :status => :moved_permanently unless @character.friendly_id_status.best?
  end
end
