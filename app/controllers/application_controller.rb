class ApplicationController < ActionController::Base
  include Pagy::Backend
  include CartsHelper
  include BooksHelper

  before_action :set_locale
  before_action :init_cart, :load_products, :ransack_books
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied, with: :deny_access

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_products
    clean_carts
    @products = Book.by_ids @carts.keys
  end

  def deny_access
    flash[:danger] = t "access_denied"
    redirect_to root_url
  end

  def configure_permitted_parameters
    added_attrs = %i(name email password password_confirmation remember_me)
    added_attrs_update = %i(name email password password_confirmation
                          remember_me address phone_num avatar)
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs_update
  end

  def ransack_books
    @search = Book.ransack(params[:q])
  end

  def after_sign_in_path_for resource
    if resource.admin?
      admin_root_path
    else
      root_path
    end
  end
end
