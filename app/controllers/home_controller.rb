class HomeController < ApplicationController
  def show
    @character = Character.new
    @characters = Character.all(:limit => 4)
  end

  def contact
  end
end
