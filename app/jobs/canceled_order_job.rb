class CanceledOrderJob < ApplicationJob
  queue_as :default

  def perform order
    @order = order
    UserMailer.canceled_order(@order).deliver_later
  end
end
