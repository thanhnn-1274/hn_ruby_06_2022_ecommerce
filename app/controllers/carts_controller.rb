class CartsController < ApplicationController
  before_action :logged_in_user, only: %i(index create)
  before_action :init_cart, only: %i(index create update destroy)
  before_action :load_product, only: %i(create update destroy)
  before_action :load_products, only: %i(index update destroy)

  def index; end

  def create
    if check_quantily @product
      add_item @product, @quantily
    else
      flash[:danger] = t ".danger_quantily"
    end
    redirect_to book_path @product.id
  end

  def update
    if @carts.key? params[:id]
      update_item
    else
      flash[:danger] = t ".fail_update"
    end
    respond_to do |format|
      format.html{redirect_to carts_path}
      format.js
    end
  end

  def destroy
    if @carts.key? params[:id]
      @carts.delete params[:id]
      user_id = session[:user_id]
      session["cart_#{user_id}"] = @carts
      load_products
    else
      flash[:danger] = t ".fail_delete"
    end
    respond_to do |format|
      format.html{redirect_to carts_path}
      format.js
    end
  end

  private

  def load_product
    @product = Book.find_by id: params[:id]
    return if @product

    flash[:danger] = t ".danger_book"
    redirect_to carts_path
  end

  def check_quantily product
    @quantily = params[:quantily].to_i
    @quantily <= product.quantity && @quantily >= Settings.carts.min_quantily
  end

  def add_item product, quantily
    if @carts.key? product.id.to_s
      @carts[product.id.to_s] += quantily
    else
      @carts[product.id.to_s] = quantily
      user_id = session[:user_id]
      session["cart_#{user_id}"] = @carts
    end
    flash[:success] = t ".success_add"
  end

  def update_item
    if check_quantily @product
      @carts[params[:id]] = @quantily
      user_id = session[:user_id]
      session["cart_#{user_id}"] = @carts
    else
      flash[:danger] = t ".danger_quantily"
    end
  end
end
