class CharactersController < ApplicationController
  def show
    api = Wowr::API.new(:character_name => 'Merb',
                          :realm => 'Baelgun',
                          :local => "tw",
                          :caching => false) # defaults to true

    @character = api.get_character
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @character }
    end
  end

end
