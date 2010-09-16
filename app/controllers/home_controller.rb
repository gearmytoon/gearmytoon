class HomeController < ApplicationController
  before_filter :cache_for_a_day
  skip_before_filter :cache_for_a_day, :only => :class_spec_list
  
  def show
    @character = Character.new
    @characters = Character.geared.level_80.all(:limit => 4)
  end
  
  def class_spec_list
    @specs = Spec.all_played_specs
  end

  def contact
  end

  private
  def cache_for_a_day
    headers['Cache-Control'] = "public, must-revalidate, max-age=#{1.day.seconds}"
  end
end
