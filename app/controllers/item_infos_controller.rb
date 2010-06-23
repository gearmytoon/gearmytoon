class ItemInfosController < ApplicationController
  
  def show
    @item = Item.find_by_wowarmory_item_id(params[:id])
  end
end