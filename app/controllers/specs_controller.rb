class SpecsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create_or_update]
  before_filter :check_basic_auth, :only => [:create_or_update]
  
  def create_or_update
    spec = Spec.find_by_wow_class_and_name(params[:spec][:wow_class_name], params[:spec][:spec_name])
    spec.update_attributes!(params[:spec].slice(:average_gmt_score, :gmt_score_standard_deviation))
    render :text => "Success!"
  end
end