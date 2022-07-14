class CompleteOrderJob < ApplicationJob
  queue_as :default

  def perform order
    @order = order
    UserMailer.complete_order(@order).deliver_later
  end
end
