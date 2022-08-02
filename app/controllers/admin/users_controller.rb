class Admin::UsersController < Admin::AdminController
  authorize_resource

  def index
    @pagy, @users = pagy User.get_all.asc_name
    return if params[:admin_search].blank?

    @pagy, @users = pagy User.search_by_name_description(params[:admin_search]
                                                         .squish)
  end
end
