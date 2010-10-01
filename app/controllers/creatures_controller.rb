class CreaturesController < ApplicationController
  before_filter :cache_for_a_hour, :only => [:show]
  
  def show
    @creature = Creature.find(params[:id], :include => [{:dropped_sources => :item}, :area])
  end
end
