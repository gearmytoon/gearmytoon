class CommentsController < ApplicationController
  before_filter :require_user, :only => [:create]
  layout false
  
  def create
    item = Item.find(params[:item_id])
    item.comments.create(params[:comment].merge({:user => current_user}))
    redirect_to item_path(item)
  end
  
  def show
    @comments = Item.find(params[:item_id]).comments.paginate(:per_page => 30, :page => params[:page], :include => :user)
  end
  
end
