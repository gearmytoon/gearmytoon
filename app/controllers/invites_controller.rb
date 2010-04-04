class InvitesController < ApplicationController
  before_filter :require_admin

  def create
    @invite = Invite.new(params[:invite])
    if @invite.save
      flash[:notice] = "Invitation Sent!"
    else
      flash[:error] = "There was a problem sending the invitation."
    end
    redirect_to account_url
  end
end
