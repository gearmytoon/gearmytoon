class ItemsController < ApplicationController
  before_filter :require_admin, :only => :index

  def index
    @items = Item.all(:order => :name)
  end

  def show
    @item = Item.find(params[:id])
    @title = "#{@item.name}"
    @meta_tags[:description] = "#{@item.name} is an epic mail belt for Rogues"
    render :partial => "tooltip" and return if request.xhr?
  end
end
