class ItemsController < ApplicationController
  before_filter :require_admin, :only => :index
  skip_before_filter :verify_authenticity_token, :only => [:update_used_by]
  before_filter :check_basic_auth, :only => [:update_used_by]
  
  def index
    @items = Item.all(:order => :name)
  end

  def show
    @item = Item.find(params[:id], :include => {:item_sources => [{:items_used_to_purchase => :currency_item}, 
                                                                  {:vendor => :area},
                                                                  {:creature => :area},
                                                                  {:quest => :area},
                                                                  {:container => :area}],
                                                :item_popularities => {:spec => :wow_class}
                                                })
    @title = "#{@item.name}"
    @meta_tags[:description] = "#{@item.name} is an epic mail belt for Rogues"
  end

  def tooltip
    @item = Item.find(params[:id])
    expires_in 3.hours, :public => true
    render :partial => "tooltip"
  end
  
  def update_used_by
    item = Item.find_by_wowarmory_item_id(params[:id])
    item_popularities = params[:item_popularities].nil? ? {} : params[:item_popularities]
    item.update_popularities!(item_popularities.values)
    render :text => "Success!"
  end
  
  protected
  def check_basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ItemSummaryPoster::LOGIN && password == ItemSummaryPoster::PASSWORD
    end
    
  end
end
