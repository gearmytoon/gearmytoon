class HomeController < ApplicationController
  def show
    @character = Character.new
    @characters = Character.found.level_80.all(:limit => 4)
  end

  def contact
  end
end
