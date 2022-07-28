class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(update)
  before_action :find_user, except: %i(new create)
  before_action :correct_user, only: %i(update)

  authorize_resource

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t(".not_found")
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def update
    if @user.update user_update_params
      flash[:success] = t ".update_success"
    else
      flash[:danger] = t ".update_fail"
    end
    redirect_to edit_user_path current_user
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t(".welcome_to")
      redirect_to root_path
    else
      flash.now[:danger] = t(".danger")
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(User::USER_ATTRS)
  end

  def user_update_params
    params.require(:user).permit(User::UPDATE_ATTRS)
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t "users.before_action.not_correct"
    redirect_to root_path
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("users.before_action.not_found")
    redirect_to root_path
  end
end
