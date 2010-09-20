class SlotsController < ApplicationController
  def show
    @spec = Spec.find(params[:spec_id], :scope => params[:scope])
    @item_popularities = @spec.item_popularities.for_slot(params[:id]).paginate(:per_page => 25, :page => params[:page], 
                                                          :order => 'average_gmt_score DESC')
    
    render :template => "specs/show"
  end
end