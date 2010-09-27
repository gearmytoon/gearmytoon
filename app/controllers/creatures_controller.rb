class CreaturesController < ApplicationController
  def show
    @creature = Creature.find(params[:id], :include => [{:dropped_sources => :item}, :area])
  end
end
