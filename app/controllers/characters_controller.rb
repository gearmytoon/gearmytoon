class CharactersController < ApplicationController
  helper :areas
  before_filter :require_user, :except => [:show, :pvp]
  before_filter :require_admin, :only => :index
  
  before_filter :assign_character, :only => [:show, :pvp]
  before_filter :redirect_to_current_url, :only => :show
  before_filter :ensure_character_level_supported, :only => :show
  before_filter :ensure_character_paid_for, :only => :show

  def index
    @characters = Character.all
  end

  def create
    begin
      @character = Character.find_or_create_by_name_and_realm_and_locale(params[:character][:name].upcase,params[:character][:realm].upcase,params[:character][:locale])
      if @character.valid?
        CharacterImporter.refresh_character!(@character)
        @current_user.user_characters.create(:character => @character)
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

  def show
    CharacterImporter.refresh_character!(@character)
  end

  def pvp
  end

  private
  def redirect_to_current_url
    redirect_to @character, :status => :moved_permanently unless @character.friendly_id_status.best?
  end
end
