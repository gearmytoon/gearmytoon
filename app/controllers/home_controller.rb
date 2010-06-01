class HomeController < ApplicationController
  before_filter :cache_for_a_day

  def show
    @character = Character.new
    @characters = Character.found.level_80.all(:limit => 4)
  end

  def contact
  end

  private
  def cache_for_a_day
    headers['Cache-Control'] = "public, must-revalidate, max-age=#{1.day.seconds}"
  end
end
