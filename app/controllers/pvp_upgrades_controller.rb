class PvpUpgradesController < ApplicationController
  before_filter :assign_character

  def frost
    @kind_of_upgrade = "Emblem of Frost"
    @upgrades = @character.frost_pvp_upgrades(params[:page])
    render "show"
  end
  
  def triumph
    @kind_of_upgrade = "Emblem of Triumph"
    @upgrades = @character.triumph_pvp_upgrades(params[:page])
    render "show"
  end

  def honor
    @kind_of_upgrade = "Honor Point"
    @upgrades = @character.honor_point_pvp_upgrades(params[:page])
    render "show"
  end
  
  def wintergrasp
    @kind_of_upgrade = "Wintergrasp Mark of Honor"
    @upgrades = @character.wintergrasp_mark_pvp_upgrades(params[:page])
    render "show"
  end
  
  def arena
    @kind_of_upgrade = "Arena Point"
    @upgrades = @character.arena_point_pvp_upgrades(params[:page])
    render "show"
  end
end
