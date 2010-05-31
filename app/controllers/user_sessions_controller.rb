class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  skip_before_filter :verify_authenticity_token, :only => [:rpx_create]

  def new
    @user_session = UserSession.new
  end

  def rpx_create
    data = RPXNow.user_data(params[:token])
    if data.blank?
      failed_login "Authentication failed."
    else
      @user = User.find_or_initialize_by_identity_url(data[:identifier])
      if @user.new_record?
        @user.name = data[:displayName] || data[:name] || data[:username]
        @user.email = data[:email] || data[:verifiedEmail]
        @user.password = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{@user.email}--")[0, 6]
        @user.save
      end
      @user_session = UserSession.create(@user)
      assign_admin_session if @user_session.record.admin
      successful_login
    end
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      assign_admin_session if @user_session.record.admin
      successful_login
    else
      failed_login
    end
  end

  def destroy
    current_user_session.try(:destroy)
    current_admin_session.try(:destroy)
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end

  protected
  def failed_login(message = nil)
    flash[:error] = message
    render :action => 'new'
  end

  def successful_login
    flash[:notice] = "Login successful!"
    redirect_back_or_default account_url
  end

  def assign_admin_session
    @user_session = UserSession.new(@user)
    @user_session.id = :admin
    @user_session.save
  end
end
