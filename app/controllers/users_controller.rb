class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  # before_filter :require_invite_token, :only => [:new, :create]
  # after_filter :destroy_invite, :only => [:create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end

  def show
    @user = @current_user
    @character = Character.new
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  private
  def require_invite_token
    if params[:invite] && @invite = Invite.find_by_token(params[:invite][:token])
      return true
    else
      flash[:notice] = 'You need a valid invite to create an account'
      redirect_to interested_url
      false
    end
  end

  def destroy_invite
    @invite.destroy if @invite && !@user.new_record?
  end
end
