# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_user_session, :current_user, :current_admin_session, :current_admin
  filter_parameter_logging :password, :password_confirmation
  before_filter :setup_meta_tags

  protected

  def cache_for_a_day
    headers['Cache-Control'] = "public, must-revalidate, max-age=#{1.day.seconds}"
  end

  def cache_for_a_hour
    headers['Cache-Control'] = "public, must-revalidate, max-age=#{1.hour.seconds}"
  end

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

  def check_basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ItemSummaryPoster::LOGIN && password == ItemSummaryPoster::PASSWORD
    end
  end

  private
  def setup_meta_tags
    @meta_tags = {}
    @meta_tags[:keywords] = "world of warcraft, gear, toon, upgrade, emblem of frost, emblem of triumph, druid, death knight, hunter, mage, paladin, priest, rogue, shaman, warlock, warrior"
    @meta_tags[:description] = "Find the best upgrades for your World of Warcraft toon. Put away the spreadsheets and stop scouring forums."
    @meta_tags
  end

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
    if request.post? && request.env["HTTP_REFERER"]
      session[:return_to] = request.env["HTTP_REFERER"]
    else
      session[:return_to] = request.request_uri
    end
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
