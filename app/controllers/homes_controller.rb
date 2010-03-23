class HomesController < ApplicationController
  def show
    @character = Character.new(:realm => "Baelgun")
  end
end
