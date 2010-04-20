class PvpUpgradesController < ApplicationController
  before_filter :assign_character

  def frost
    @upgrades = @character.frost_upgrades
    render "show"
  end
  
  def triumph
    @upgrades = @character.triumph_upgrades
    render "show"
  end

  def honor
    @upgrades = @character.honor_point_upgrades
    render "show"
  end
  
  def wintergrasp
    @upgrades = @character.wintergrasp_mark_upgrades
    render "show"
  end
end
