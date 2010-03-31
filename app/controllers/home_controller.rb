class HomeController < ApplicationController
  def index
    @character = Character.new(:realm => "Baelgun")
  end
end
