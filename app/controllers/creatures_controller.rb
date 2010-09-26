class CreaturesController < ApplicationController
  def show
    @creature = Creature.find(params[:id])
  end
end
