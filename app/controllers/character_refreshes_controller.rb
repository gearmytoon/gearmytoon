class CharacterRefreshesController < ApplicationController
  def show
    character_refresh = CharacterRefresh.find(params[:id])
    respond_to do |format|
      format.json do
        render :json => {:status => character_refresh.status}
      end
    end
  end
end
