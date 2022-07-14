class Admin::OrdersController < Admin::AdminController
  before_action :find_order, only: %i(show update)
  before_action :load_order_details, only: %i(show)
  before_action :check_status_order, only: %i(update)

  def index
    if params[:status]
      filter
    else
      @pagy, @orders = pagy Order.latest_order
    end
  end

  def show
    respond_to :js
  end

  def update
    if @order.handle_order order_params
      flash[:success] = t(".success")
      send_mail_notification
    else
      flash.now[:danger] = t(".danger")
    end
    redirect_to admin_orders_path
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end

  def load_order_details
    @order_details = @order.order_details
    return if @order_details

    flash[:danger] = t ".not_found"
    redirect_to admin_order_path
  end

  def find_order
    @order = Order.find_by id: params[:id]

    return if @order

    flash[:warning] = t(".not_found")
    redirect_to root_path
  end

  def check_status_order
    return if @order.pending? || @order.accepted?

    flash[:danger] = t ".danger"
    redirect_to admin_orders_path
  end

  def filter
    sort
    statuses = Order.statuses.values
    return unless statuses.include? params[:status].to_i

    @pagy, @orders = pagy(@orders.status_order(params[:status].to_sym))
  end

  def send_mail_notification
    status = @order.status
    @order.send "send_mail_#{status}"
  end

  def sort
    @pagy, @orders = pagy(Order.search(params[:search])
                               .time_order(params[:updated_at].to_sym)
                               .total_money(params[:price].to_sym))
  end
end
