class OrdersController < ApplicationController
  before_action :logged_in_user, only: %i(new create)
  before_action :init_cart
  before_action :load_products
  before_action :check_product_quantity, only: %i(new create)

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
    @orders = current_user.orders.latest_order
  end

  def sort
    statuses = Order.statuses.keys

    @orders = current_user.orders.latest_order

    if statuses.include? params[:sort]
      @orders = @orders.status_order(params[:sort].to_sym)
    end

    respond_to :js
  end

  private

  def order_params
    params.require(:order).permit Order::ORDER_ATTRS
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
end
