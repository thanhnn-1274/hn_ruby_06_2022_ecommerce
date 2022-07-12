class UsersController < ApplicationController
  before_action :set_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: [:edit, :update, :buy]
  attr_accessor :name, :email

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to root_path
    else
      render "new"
    end
  end

  def buy; end

  def update; end

  def destroy; end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = "Please log in."
    redirect_to login_path
  end
end
