class SpecsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create_or_update]
  before_filter :check_basic_auth, :only => [:create_or_update]
  
  def show
    @spec = Spec.find(params[:id], :scope => params[:scope])
    @item_popularities = @spec.item_popularities.paginate(:per_page => 25, :page => params[:page], 
                                                          :order => 'average_gmt_score DESC', :include => :item,
                                                          :conditions => ["items.slot != 'Tabard' AND items.slot != 'Shirt'"])
  end
  
  def index
    @specs = Spec.all_played_specs
  end

  def create_or_update
    spec = Spec.find_by_wow_class_and_name(params[:spec][:wow_class_name], params[:spec][:spec_name])
    spec.update_attributes!(params[:spec].slice(:average_gmt_score, :gmt_score_standard_deviation))
    render :text => "Success!"
  end
end
