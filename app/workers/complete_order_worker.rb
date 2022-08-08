class CompleteOrderWorker
  include Sidekiq::Worker

  def perform order_id
    @order = Order.find_by id: order_id
    UserMailer.complete_order(@order).deliver_later
  end
end
