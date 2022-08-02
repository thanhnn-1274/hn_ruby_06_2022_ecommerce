class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper
  include CartsHelper
  include BooksHelper

  before_action :set_locale
  before_action :init_cart, :load_products

  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied, with: :deny_access

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("users.before_action.please_login")
    redirect_to login_path
  end

  def load_products
    clean_carts
    @products = Book.by_ids @carts.keys
  end

  def deny_access
    flash[:danger] = t "access_denied"
    redirect_to root_url
  end
end
