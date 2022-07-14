class Admin::OrdersController < Admin::AdminController
  def index
    @pagy, @orders = pagy Order.latest_order
  end
end
