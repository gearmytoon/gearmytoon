class CreaturesController < ApplicationController
  
  def show
    @creature = Creature.find(params[:id])
    expires_in 3.hours, :public => true
    return if fresh_when(:last_modified => @creature.updated_at.utc) #return if the cached copy is still good
    @creature = Creature.find(params[:id], :include => [{:dropped_sources => :item}, :area])
  end
end
