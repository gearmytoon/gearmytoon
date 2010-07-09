# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_user_session, :current_user, :current_admin_session, :current_admin
  filter_parameter_logging :password, :password_confirmation

  protected

  def assign_character
    headers['Cache-Control'] = 'public, must-revalidate'
    @character = params[:character_id] ? Character.find(params[:character_id]) : Character.find(params[:id])
    return(redirect_to not_found_character_url(@character)) if @character.does_not_exist?
    @character.refresh_in_background! if @character.updated_at < 5.minutes.ago
    return if fresh_when(:last_modified => @character.updated_at.utc)
    return(render "characters/new_character") if(@character.is_new?)
    return(render "characters/unsupported_level") unless(@character.level == 80)
    return(render "characters/unpaid") unless(@character.paid?)
    return(render "characters/being_geared") if(@character.has_no_upgrades_yet?)
  end

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  #admin
  def current_admin_session
    return @current_admin_session if defined?(@current_admin_session)
    @current_admin_session = UserSession.find(:admin)
  end

  def current_admin
    return @current_admin if defined?(@current_admin)
    @current_admin = current_admin_session && current_admin_session.record
  end

  def require_admin
    unless current_admin && current_admin.admin
      redirect_to root_url
      return false
    end
  end
end
