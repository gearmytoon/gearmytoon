class CommentsController < ApplicationController
  before_filter :require_user, :only => [:create]
  layout false
  
  def create
    item = Item.find(params[:item_id])
    item.comments.create(params[:comment].merge({:user => current_user}))
    render :text => "Profit"
  end
  
  def show
    @comments = Comment.paginate(:per_page => 30, :page => params[:page], :conditions => {:commentable_id => params[:item_id]}, :include => :user)
  end
  
end
