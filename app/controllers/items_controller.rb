class ItemsController < ApplicationController
  def show
    @item = Item.find(params[:id])
  end

  def tooltip
    @item = Item.find(params[:id])
    render :partial => "items/item_tooltip"
  end
end
