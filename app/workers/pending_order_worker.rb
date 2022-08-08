class PendingOrderWorker
  include Sidekiq::Worker

  def perform order_id
    @order = Order.find_by id: order_id
    UserMailer.pending_order(@order).deliver_later
  end
end
