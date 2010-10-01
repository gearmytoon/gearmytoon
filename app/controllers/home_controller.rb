class HomeController < ApplicationController
  before_filter :cache_for_a_day
  
  def show
    @character = Character.new
    @characters = Character.geared.level_80.all(:limit => 4)
  end
  
  def contact
  end

end
