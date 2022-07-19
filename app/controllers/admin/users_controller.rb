class Admin::UsersController < Admin::AdminController
  def index
    @pagy, @users = pagy User.get_all.asc_name
  end
end
