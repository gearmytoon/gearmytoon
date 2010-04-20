class PvpUpgradesController < ApplicationController
  before_filter :assign_character

  def frost
    @upgrades = @character.frost_pvp_upgrades
    render "show"
  end
  
  def triumph
    @upgrades = @character.triumph_pvp_upgrades
    render "show"
  end

  def honor
    @upgrades = @character.honor_point_pvp_upgrades
    render "show"
  end
  
  def wintergrasp
    @upgrades = @character.wintergrasp_mark_pvp_upgrades
    render "show"
  end
  
  def arena
    @upgrades = @character.arena_point_pvp_upgrades
    render "show"
  end
end
