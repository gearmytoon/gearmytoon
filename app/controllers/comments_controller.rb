class CommentsController < ApplicationController
  before_filter :require_user, :only => [:create]
  before_filter :public_must_revalidate, :only => :show
  skip_before_filter :verify_authenticity_token, :only => [:create]
  
  layout false
  
  def create
    item = Item.find(params[:item_id])
    item.comments.create(params[:comment].merge({:user => current_user}))
    redirect_to item_path(item)
  end
  
  def show
    item = Item.find(params[:item_id])
    response.etag = item.comments
    if request.fresh?(response)
      head :not_modified
    else
      @comments = item.comments.paginate(:per_page => 30, :page => params[:page], :include => :user)
    end
  end
  
end
