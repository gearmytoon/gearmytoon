class HomesController < ApplicationController
  def show
    @character = Character.new(:realm => "Baelgun")
  end
  
  def no_such_character
    @character = Character.new(:realm => params[:realm], :name => params[:name])
    flash.now[:error] = "Sorry we could not locate the character #{params[:name]} on #{params[:realm]}, please ensure the spelling is correct."
    render "show"
  end
end
