class HomeController < ApplicationController
  def index
    @character = Character.new(:realm => "Baelgun")
  end

  def interested
    if request.post?
      @beta_participant = BetaParticipant.new(params[:beta_participant])
      if @beta_participant.save
        flash[:notice] = 'Thanks for your interest!'
        redirect_to root_url
      end
    else
      @beta_participant = BetaParticipant.new
    end
  end
end
