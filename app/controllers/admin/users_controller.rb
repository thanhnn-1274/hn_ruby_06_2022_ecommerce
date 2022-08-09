class Admin::UsersController < Admin::AdminController
  authorize_resource

  def index
    @search = User.ransack(params[:q])
    @pagy, @users = pagy @search.result.get_all.asc_name
  end

  def ban
    @user = User.find_by id: params[:id]

    if @user.access_locked?
      @user.unlock_access!
    else
      @user.lock_access!
    end
    redirect_to admin_users_path
  end
end
