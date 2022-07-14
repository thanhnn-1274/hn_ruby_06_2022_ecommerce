class Admin::AdminController < ApplicationController
  before_action :require_admin
  layout "admin/layouts/application"

  private
  def require_admin
    return admin_root_path if current_user&.admin?

    flash[:danger] = t "admin_danger"
    redirect_to root_path
  end
end
