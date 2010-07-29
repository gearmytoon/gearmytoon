class AreaUpgradesController < ApplicationController
  before_filter :assign_character

  def show
    area = Area.find(params[:id])
    @kind_of_upgrade = area.full_name
    @upgrades = @character.area_upgrades(params[:page], area)
    @title = "#{@kind_of_upgrade} Upgrades for #{@character.name.capitalize} of #{@character.realm.capitalize} &mdash; gearmytoon.com"
    render "upgrades/show"
  end
end
