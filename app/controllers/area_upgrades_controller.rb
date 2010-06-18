class AreaUpgradesController < ApplicationController
  before_filter :assign_character

  def show
    area = Area.find(params[:id])
    @kind_of_upgrade = area.full_name
    @upgrades = @character.area_upgrades(params[:page], area)
    render "upgrades/show"
  end
end