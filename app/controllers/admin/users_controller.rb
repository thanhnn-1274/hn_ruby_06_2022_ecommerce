class Admin::UsersController < Admin::AdminController
  def index
    @pagy, @users = pagy User.get_all.asc_name
    return if params[:admin_search].blank?

    @pagy, @users = pagy User.search_by_name(params[:admin_search].squish)
  end
end
