class CharactersController < ApplicationController
  def show
    @api = Wowr::API.new(:character_name => 'Merb',
                          :realm => 'Baelgun',
                          :local => "tw",
                          :caching => true) # defaults to true

    @character = @api.get_character
    # @character = Character.first
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @character }
    end
  end

end
