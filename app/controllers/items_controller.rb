class ItemsController < ApplicationController
  before_filter :require_admin, :only => :index

  def index
    @items = Item.all(:order => :name)
  end

  def show
    @item = Item.find(params[:id], :include => {:item_sources => [{:items_used_to_purchase => :currency_item}, 
                                                                  {:vendor => :area},
                                                                  {:creature => :area},
                                                                  {:quest => :area},
                                                                  {:container => :area}]
                                                })
    @title = "#{@item.name}"
    @meta_tags[:description] = "#{@item.name} is an epic mail belt for Rogues"
  end

  def tooltip
    @item = Item.find(params[:id])
    expires_in 3.hours, :public => true
    render :partial => "tooltip"
  end
end
