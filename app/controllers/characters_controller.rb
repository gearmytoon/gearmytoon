class CharactersController < ApplicationController
  helper :areas
  before_filter :require_user, :except => :show

  def index
    @characters = Character.all
  end

  def create
    if c = Character.find_by_name_and_realm(params[:character][:name].upcase,params[:character][:realm].upcase)
      redirect_to character_path(c)
    else
      begin
        @character = Character.new(params[:character])
        @character.user = current_user
        if @character.save
          flash[:notice] = "Toon added successfully!"
          redirect_to character_path(@character)
        else
          flash[:error] = "There was a problem adding that character"
          redirect_to account_url
        end
      rescue Wowr::Exceptions::CharacterNotFound
        render "#{RAILS_ROOT}/public/404.html", :status => 404
      end
    end
  end

  def show
    @character = Character.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @character }
    end
  end
end
