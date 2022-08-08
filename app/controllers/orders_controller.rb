class OrdersController < ApplicationController
  before_action :authenticate_user!, only: %i(new create)
  before_action :init_cart
  before_action :load_products
  before_action :check_product_quantity, only: %i(new create)
  before_action :find_order, only: %i(show update)
  before_action :load_order_details, only: %i(show)
  before_action :check_status_order, only: %i(update)

  authorize_resource

  def new
    @order = current_user.orders.build
  end

  def create
    @order = current_user.orders.new order_params
    if @order.valid?
      create_transaction
    else
      flash[:danger] = t ".order_fail"
      render :new
    end
  end

  def index
    @search_orders = Order.ransack(params[:p])
    @orders = @search_orders.result.accessible_by(current_ability).latest_order
  end

  def update
    if @order.update(reason: params_reason[:reason], status: :canceled)

      flash[:success] = t ".success"
    else
      flash.now[:danger] = t ".danger"
    end
    redirect_to orders_url
  end

  def show
    respond_to :js
  end

  private

  def order_params
    params.require(:order).permit Order::ORDER_ATTRS
  end

  def params_reason
    params.require(:order).permit :reason
  end

  def create_order_detail
    @products.each do |item|
      product_id = item.id.to_i
      @order.order_details.create!(
        book_id: product_id,
        quantity: @carts[product_id.to_s],
        price: item.price,
        total_money: @carts[product_id.to_s] * item.price
      )
    end
  end

  def load_order_details
    @order_details = @order.order_details
    return if @order_details

    flash[:danger] = t ".not_found"
    redirect_to orders_url
  end

  def create_transaction
    ActiveRecord::Base.transaction do
      @order.save!
      create_order_detail
      clear_carts
      redirect_to root_path
      flash[:success] = t ".success_checkout"
    end
  rescue StandardError
    flash[:danger] = t ".danger_checkout"
    redirect_to carts_path
  end

  def find_order
    @order = Order.find_by id: params[:id]

    return if @order

    flash[:warning] = t ".not_found"
    redirect_to root_path
  end

  def check_status_order
    return if @order.pending?

    flash[:danger] = t ".danger"
    redirect_to orders_path
  end
end
