class Admin::UsersController < Admin::AdminController
  authorize_resource

  def index
    @search = User.ransack(params[:q])
    @pagy, @users = pagy @search.result.get_all.asc_name
  end
end
